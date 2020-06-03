#version 120

attribute vec4 mc_Entity;

varying vec4 texcoord;
varying vec4 color;
varying float isTransparent;

float getIsTransparent(in float materialId) {
    if (materialId == 8.0 || materialId == 9.0) return 1.0;
    if (materialId == 79.0) return 1.0;
    if (materialId == 90.0) return 1.0;
    if (materialId == 95.0) return 1.0;
    if (materialId == 160.0) return 1.0;
    return 0.0;
}

void main() {

    texcoord = gl_MultiTexCoord0;
    color = gl_Color;

    isTransparent = getIsTransparent(mc_Entity.x);

    gl_Position = ftransform();

}