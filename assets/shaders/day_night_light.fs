
//Day-Night cycle
extern vec4 COLOR_MIX; //Will be the precalculated lerp
extern vec3 CONSTRAST_BRIGHTNESS_SATURATION;
extern vec2 HIGHLIGHT;

const float eyeThreshold = 250/255;

#define CONTRAST CONSTRAST_BRIGHTNESS_SATURATION.x
#define BRIGHTNESS CONSTRAST_BRIGHTNESS_SATURATION.y
#define SATURATION CONSTRAST_BRIGHTNESS_SATURATION.y

#define HIGHLIGHT_STRENGTH HIGHLIGHT.x
#define HIGHLIGHT_THRESHOLD HIGHLIGHT.y

#define MAX_LIGHTS 32
#define foreach(count, max) for(int count = 0; count < max; count++)

struct Light
{
    vec2 position;
    vec3 diffuse;
    float power;
    float falloff;
    float maxThreshold;
    float minThreshold;
};

//Lighting
extern Light LIGHTS[MAX_LIGHTS];
extern int LIGHTS_COUNT;
extern vec2 SCREEN;
extern vec2 CAM_POSITION;



vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    //Current pixel
    vec4 pixel = Texel(texture, texture_coords);

    //Makes the red eye appears
    if(pixel.r >= eyeThreshold && pixel.g == 0 && pixel.b == 0)
        return vec4(1,0,0,1);


    vec3 out_col = pixel.rgb;
    float grey = dot(out_col, vec3(0.299, 0.587, 0.114));

    //Add constrast
    out_col = (out_col - 0.5) * CONTRAST + 0.5;

    //Add highlights (pop lights)
    out_col = out_col + HIGHLIGHT_STRENGTH * max(grey - HIGHLIGHT_THRESHOLD, 0.0);

    //Add saturation
    out_col = mix(vec3(grey), out_col, SATURATION);
    //Add brightness
    out_col = out_col + BRIGHTNESS;
    
    pixel = pixel*vec4(out_col, 1);
    

    vec2 norm_screen = (CAM_POSITION+screen_coords);
    vec3 diffuse = vec3(0);

    foreach(i, LIGHTS_COUNT)
    {
        Light l = LIGHTS[i];

        float dist = length(norm_screen-(l.position));

        float lightP;
        if(dist > l.maxThreshold) //Ok
            lightP = 0;
        else if(dist < l.minThreshold)
            lightP = l.power;
        else
            lightP = l.power/(dist*dist*l.falloff);

        diffuse+= l.diffuse*lightP;
    }

    
    diffuse = clamp(diffuse, 0.0, 1.0);
    


    vec4 ndiffuse = vec4(diffuse, 1);


    // return pixel*color*mix(out_col, COLOR_MIX, ndiffuse);

    vec4 c = vec4(COLOR_MIX);


    // return ((ndiffuse*pixel) * (vec4(1)-ndiffuse)*COLOR_MIX) * color;

    // pixel = pixel*vec4(out_col, 1);
    return clamp((ndiffuse+COLOR_MIX), 0, 1)*pixel;
}