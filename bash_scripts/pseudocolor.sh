
# boosts levels and then adds gradient for out of range pixels using pseudocolor

# boost levels
ffmpeg -i /Users/pamiqc/Desktop/LiquidLoopsClip.mp4 -vf eq=brightness=0.40:saturation=8 -c:a copy brightLiquidTest.mp4

# pseudocolor gradient for high levels
ffmpeg -i /Users/pamiqc/brightLiquidTest.mp4 -vf pseudocolor="'if(between(val,ymax,amax),lerp(ymin,ymax,(val-ymax)/(amax-ymax)),-1):if(between(val,ymax,amax),lerp(umax,umin,(val-ymax)/(amax-ymax)),-1):if(between(val,ymax,amax),lerp(vmin,vmax,(val-ymax)/(amax-ymax)),-1):-1'" test2.mp4
