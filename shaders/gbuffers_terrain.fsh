#version 120

#include "/lib/framebuffer.glsl"

varying vec3 color;
varying vec3 normal;
varying vec4 texcoord;
varying vec4 lmcoord;

uniform sampler2D colorTexture;

void main() {
    vec4 blockColor = texture2D(colorTexture, texcoord.st);
    blockColor.rgb *= color;

    GCOLOR_OUT = blockColor;
    GDEPTH_OUT = vec4(lmcoord.st / 16.0, 0.0, 0.0);
    GNORMAL_OUT = vec4(normal * 0.5 + 0.5, 0.0);
}