#define MAX_LIGHTS 32
#define foreach(count, max) for(int #count = 0; #count < max; #count++)

struct Light
{
    vec2 position;
    vec3 diffuse;
    float power;
};

//Lighting
extern Light LIGHTS[MAX_LIGHTS];
extern int LIGHTS_COUNT;
extern vec2 SCREEN;

const float constant = 1; //?
const float linear = 0.09;
const float quadratic = 0.032; 

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 pixel = Texel(texture, texture_coords);
    //Create lighting
    vec2 norm_screen = SCREEN/screen_coords;
    vec3 diffuse = vec3(0);

    foreach(i, LIGHTS_COUNT)
    {
        Light l = LIGHTS[i];
        vec2 l_norm_pos = l.position / SCREEN;

        float dist = length(l_norm_pos - norm_screen);
        float attenuation = 1.0 / (constant + linear * distance + quadratic * (dist*dist));

        diffuse+= l.diffuse;
    }

    diffuse = clamp(diffuse, 0.0, 1.0);

    return pixel*vec4(diffuse, 1.0);
}