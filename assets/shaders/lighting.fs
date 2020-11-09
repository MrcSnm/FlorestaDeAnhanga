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
    vec4 pixel = Texel(texture, texture_coords);
    //Create lighting
    vec2 d = vec2(SCREEN+CAM_POSITION);
    vec2 norm_screen = (CAM_POSITION+screen_coords);
    vec3 diffuse = vec3(0.0);

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
            lightP = l.power/(dist*l.falloff);

        diffuse+= l.diffuse*lightP;
    }

    
    diffuse = clamp(diffuse, 0.0, 1.0);

    

    return pixel*vec4(diffuse, 1.0);
}