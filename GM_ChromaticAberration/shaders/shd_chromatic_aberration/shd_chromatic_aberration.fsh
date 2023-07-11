/*
    "Chromatic Aberration" by @XorDev
    
    Here's a super simple "Chromatic Aberration" effect that you can
    easily add as a post-process effect to other shaders.
    
    Mini tut: https://mini.gmshaders.com/p/gm-shaders-mini-chromatic-aberration
    
    Used here: https://www.shadertoy.com/view/mdfGRs
*/

//Direction of aberration
uniform vec2 u_vector;
//Texel size (reciprocal of resolution)
uniform vec2 u_texel;

//Contrast amount
#define CONTRAST 2.0
//Must be an even number
#define SAMPLES 20.0
//Aberration mode
#define MODE LINEAR

#define LINEAR 0
#define RADIAL 1
#define TWIST  2

varying vec2 v_coord;
varying vec4 v_color;

void main()
{
    vec2 uv = v_coord;
	//Aberration vector
    vec2 v = u_vector;
	//Amplitude
	float a = length(v);
    //Color output starts at 0.
	vec4 color_sum = vec4(0);
    vec4 weight_sum = vec4(0);
    
    //Iterate 20 times from 0 to 1
	for(float i = 0.0; i<=1.0; i+=1.0/SAMPLES)
    {
        //Add a texture sample approaching the center (0.5, 0.5)
        //This center could moved to change how the direction of aberation
        //The mix amount determines the intensity of the aberration smearing
        vec2 coord = uv;
        
        #if (MODE==LINEAR)
            coord = uv+0.04*(i-.5)*v;
        #elif (MODE==RADIAL)
            coord = mix(uv, vec2(.5), (i-.5)*.1*a);
        #elif (MODE==TWIST)
            vec2 ratio = u_texel.y/u_texel.yx;
            coord = uv+vec2(uv.y-.5, .5-uv.x)*ratio*ratio*(i-.5)*.1*a;
        #endif
        
        vec4 weight = vec4(i,1.-abs(i+i-1.),1.-i,.5);
        weight = mix(vec4(.5), weight,  CONTRAST);
        
        vec4 color = texture2D(gm_BaseTexture, coord);
		color_sum += color * color * weight;
        //This makes each sample have a different color from red to green to blue
        //The total should be multiplied by the 2/number of samples, (e.g. 0.1)
        weight_sum += weight;
    }
    
    //Output the resulting color
    gl_FragColor = v_color * sqrt(color_sum / weight_sum);
}