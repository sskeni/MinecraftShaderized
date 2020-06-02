#version 120

#include "/lib/framebuffer.glsl"

varying vec3 color;
varying vec3 normal;
varying vec4 texcoord;
varying vec4 lmcoord;

varying float water;
varying float ice;
varying float stainedGlass;
varying float stainedGlassPlane;
varying float netherPortal;

uniform sampler2D texture;

void main() {
    vec4 baseColor = texture2D(texture, texcoord.st);
    baseColor.rgb *= color;

    float material = 0.01;
    if (water > 0.9) material = 0.1;
    if (ice > 0.9) material = 0.2;
    if (stainedGlass > 0.9) material = 0.3;
    if (stainedGlassPlane > 0.9) material = 0.3;

    GCOLOR_OUT = baseColor;
    GDEPTH_OUT = vec4(lmcoord.st / 16.0, material, 0.0);
    GNORMAL_OUT = vec4(normal * 0.5 + 0.5, 1.0);
}