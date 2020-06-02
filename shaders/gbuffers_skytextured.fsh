#version 120

#include "/lib/framebuffer.glsl"

varying vec4 color;
varying vec2 texcoord;

uniform sampler2D texture;

void main() {
    gl_FragData[0] = texture2D(texture, texcoord.st) * color;
}