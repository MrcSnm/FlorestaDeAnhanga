
extern float RATIO; //Ratio, calculated  by 

extern vec4 FIRST_COLOR; //Sent based on time
extern vec4 SECOND_COLOR;//Sent based on time + (1/number of colors)

vec4 colorMix(vec4 c1, vec4 c2, float ratio)
{
    return vec4(mix(c1.r, c2.r, ratio), mix(c1.g, c2.g, ratio), mix(c1.b, c2.b, ratio), mix(c1.a, c2.a, ratio));
}


vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 pixel = Texel(texture, texture_coords);
    vec4 retcolor = colorMix(FIRST_COLOR, SECOND_COLOR, RATIO);
    return pixel*retcolor*color;
}