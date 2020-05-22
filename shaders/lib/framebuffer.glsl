// Contains various functions for global use

// Define color, depth, and normal spaces
const int RGBA = 0;
const int RGBA16 = 1;

const int gcolorFormat = RGBA16;
const int gdepthFormat = RGBA;
const int gnormalFormat = RGBA16;

// Shadow stuff
const int shadowMapResolution = 4096;
const float sunPathRotation = 25.0;

// Color, depth, and normal samples
uniform sampler2D gcolor;
uniform sampler2D gdepth;
uniform sampler2D gnormal;

#define GCOLOR_OUT gl_FragData[0]
#define GDEPTH_OUT gl_FragData[1]
#define GNORMAL_OUT gl_FragData[2]

// Get the albedo at a given coordinate
vec3 getAlbedo(in vec2 coord) {
    return pow(texture2D(gcolor, coord).rgb, vec3(2.2));
}

// Get the normal at a given coordinate
vec3 getNormal(in vec2 coord) {
    return texture2D(gnormal, coord).rgb * 2.0 - 1.0;
}

// Get emission at a given coordinate
float getEmission(in vec2 coord) {
    return texture2D(gdepth, coord).a;
}

// Get strength of light blocks (not just torches)
float getTorchLightStrength(in vec2 coord) {
    return texture2D(gdepth, coord).r;
}

// Get strength of the sky light
float getSkyLightStrength(in vec2 coord) {
    return texture2D(gdepth, coord).g;
}