%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Instituto Superior Técnico          %
%                                              %
%             Speech Processing                %
%                                              %
%               Laboratório - 2                %
%                                              %
%                  Grupo 8                     %
%                                              %
%      Student - José  Diogo    - Nº 75255     %
%      Student - Rúben Tadeia   - Nº 75268     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Part 3 - Vocoder Simulation
% Normal functioning of the Vocoder:
% We start using a Pitch detector to undertand if it is a voiced or 
% unvoiced sound.
% Then we generate a random excitation on Unvoiced sounds and impulse
% train (dirac) when voiced.
% After know the gain of each windows of the residual in part 2 we then
% calculate the output file using the inverse filter.

    clear; clf
    infile='birthdate_75255.wav';
    outfile='birthdate_75255_voc.wav';
    time=0;                                    % total time
    hopInput=121;                              % hop length for input file
    hopOutput=242;                             % hop length for output

    all2pi=2*pi*(0:100);                       % all multiples of 2 pi (used in PV-style freq search) 
    max_peak=50;                               % parameters for peak finding: number of peaks
    eps_peak=0.005;                            % height of peaks
    nfft=2^12; nfft2=nfft/2;                   % fft length 
    win=hanning(nfft)';                        % windows and windowing variables   
    
    %reading input file
    [y,sr]=audioread(infile)
    siz=audioread(infile);                     % length of song in samples
    stmo=min(siz); leny=max(siz);              % stereo (stmo=2) or mono (stmo=1)
    if siz(2)<siz(1), y=y'; end
    if time==0, time = 100000; end
    tt=zeros(stmo,ceil(hopOutput/hopInput)*fix(min(leny,time*sr))); % place for output 
    lenseg=floor((min(leny,time*sr)-nfft)/hopInput) % number of nfft segments to process

    ssf=sr*(0:nfft2)/nfft;                     % frequency vector
    phold=zeros(stmo,nfft2+1); phadvance=zeros(stmo,nfft2+1);
    outbeat=zeros(stmo,nfft); pold1=[]; pold2=[];
    dtin=hopInput/sr;                             % time advances dt per hop for input
    dtout=hopOutput/sr;                           % time advances dt per hop for output
    
    % main loop - process each beat separately
    for k=1:lenseg-1                           
        if k/1000==round(k/1000), disp(k), end % for display so I know where we are
        indin=round(((k-1)*hopInput+1):((k-1)*hopInput+nfft));
        
        % do Left and right channels separately
        for sk=1:stmo                          
            s=win.*y(sk,indin);    % get this frame and take FFT
            ffts=fft(s);
            mag=abs(ffts(1:nfft2+1)); 
            ph=angle(ffts(1:nfft2+1));

            % find peaks to define spectral mapping

            peaks=findPeaks4(mag, max_peak, eps_peak, ssf);
            [dummy,inds]=sort(mag(peaks(:,2)));
            peaksort=peaks(inds,:);
            pc=peaksort(:,2);
            
            bestf=zeros(size(pc));
             % estimate frequency using Phase Vocoder strategy 
            for tk=1:length(pc)                
                dtheta=(ph(pc(tk))-phold(sk,pc(tk)))+all2pi;
                fest=dtheta./(2*pi*dtin);
                [er,indf]=min(abs(ssf(pc(tk))-fest));
                % finding the best freq estimate for each row
                bestf(tk)=fest(indf);       
            end

            % generate output magnitude and phase
            magout=mag; phout=ph;
            
            for tk=1:length(pc)
                fdes=bestf(tk);                           % reconstruct with original frequency
                freqind=(peaksort(tk,1):peaksort(tk,3));  % indices of the surrounding bins
                
                % specify magnitude and phase of each partial
                magout(freqind)=mag(freqind);
                phadvance(sk,peaksort(tk,2))=phadvance(sk,peaksort(tk,2))+2*pi*fdes*dtout;
                pizero=pi*ones(1,length(freqind));
                pcent=peaksort(tk,2)-peaksort(tk,1)+1;
                indpc=(2-mod(pcent,2)):2:length(freqind);
                pizero(indpc)=zeros(1,length(indpc));
                phout(freqind)=phadvance(sk,peaksort(tk,2))+pizero;
            end

            % reconstruct time signal (stretched or compressed)

            compl=magout.*exp(sqrt(-1)*phout);
            compl(nfft2+1)=ffts(nfft2+1);
            compl=[compl,fliplr(conj(compl(2:(nfft2))))];
            wave=real(ifft(compl));
            outbeat(sk,:)=wave;
            phold(sk,:)=ph; 
            
        end % end stereo
        indout=round(((k-1)*hopOutput+1):((k-1)*hopOutput+nfft));
        tt(:,indout)=tt(:,indout)+outbeat;
    end
    tt=0.8*tt/max(max(abs(tt)));
    [rtt,ctt]=size(tt); if rtt==2, tt=tt'; end
    
    % Creating the output file _voc. That should be in the same pitch
    % but with intonation
    audiowrite(outfile,5000,sr);
    fclose('all');