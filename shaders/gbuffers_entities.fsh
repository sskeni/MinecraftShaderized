#version 120

#include "/lib/framebuffer.glsl"

varying vec4 color;
varying vec3 normal;
varying vec4 texcoord;
varying vec2 lmcoord;

uniform sampler2D texture;
uniform vec4 entityColor;

void main() {
    vec4 baseColor = texture2D(texture, texcoord.st);
    baseColor *= color;
    //baseColor = mix(baseColor, entityColor, entityColor.a);

    GCOLOR_OUT = baseColor;
    GDEPTH_OUT = vec4(lmcoord.st / 16.0, 0.0, 0.0);
    GNORMAL_OUT = vec4(normal * 0.5 + 0.5, 0.0);
}