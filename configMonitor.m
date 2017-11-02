function [mon, dres, rm] = configMonitor()
    rm = max(Screen('Screens'));  % Display on remote monitor? 0=no, 1=yes.
    
    %monitor setup
    mon.wp=1024;              %Monitor resolution, horizontal (pixels)
    mon.hp=768;               %Monitor resolution, vertical (pixels)
    mon.wcm= 49.55;%38.4;             %Width of viewable portion of monitor (cm; measure to be sure)
    mon.hcm= 31;%28.8;             %Height of viewable portion of monitor (cm; measure to be sure)
    mon.dcm=67; %59;               %Distance from observer to monitor (cm; measure to be sure)
    mon.rf=85;                %Monitor refresh rate (Hz)

    mon.pcm=mon.wcm/mon.wp;                      %Size of each pixel (cm)
    mon.pd=2*atan((mon.pcm/2)/mon.dcm)*180/pi;   %Size of each pixel (deg)
    mon.wd=mon.wp*mon.pd;                        %Width of monitor (deg)
    mon.hd=mon.hp*mon.pd;                        %Height of monitor (deg)
    mon.ed=4;                        %Distance of fixation cross centers from monitor edge (degrees)
    mon.ep=round(mon.ed/mon.pd);     %Distance of fixation cross centers from monitor edge (pixels)
    AssertOpenGL; 
    dres=SetResolution(rm, mon.wp, mon.hp); %Set monitor to given parameters and store original monitor settings for reset at end of script
    
end