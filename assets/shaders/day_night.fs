
extern vec4 COLOR_MIX; //Will be the precalculated lerp
extern vec3 CONSTRAST_BRIGHTNESS_SATURATION;
extern vec2 HIGHLIGHT;

#define CONTRAST CONSTRAST_BRIGHTNESS_SATURATION.x
#define BRIGHTNESS CONSTRAST_BRIGHTNESS_SATURATION.y
#define SATURATION CONSTRAST_BRIGHTNESS_SATURATION.y

#define HIGHLIGHT_STRENGTH HIGHLIGHT.x
#define HIGHLIGHT_THRESHOLD HIGHLIGHT.y

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 pixel = Texel(texture, texture_coords);


    //Makes the red eye appears
    if(pixel.r >= 250/255 && pixel.g == 0 && pixel.b == 0)
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
    return pixel*COLOR_MIX*color;
}