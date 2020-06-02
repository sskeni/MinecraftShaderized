#version 120

attribute vec4 mc_Entity;

varying vec4 texcoord;
varying vec4 color;
varying float isTransparent;


void main() {

    texcoord = gl_MultiTexCoord0;
    color = gl_Color;

    gl_Position = ftransform();

}