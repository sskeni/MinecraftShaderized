#version 120

#include "/lib/framebuffer.glsl"

varying vec4 color;
varying vec2 texcoord;

void main() {
    GCOLOR_OUT = color;
}