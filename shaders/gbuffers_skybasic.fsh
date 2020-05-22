#version 120

#include "/lib/framebuffer.glsl"

varying vec3 tintColor;

void main() {
    GCOLOR_OUT = vec4(tintColor, 1.0);
    GNORMAL_OUT = vec4(0.0, 0.0, 0.0, 1.0);
}