#version 120

#include "/lib/framebuffer.glsl"

uniform sampler2D tex;

varying vec4 texcoord;
varying vec4 color;
varying float isTransparent;

void main() {

    GCOLOR_OUT = texture2D(tex, texcoord.st);
}