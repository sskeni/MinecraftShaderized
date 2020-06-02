#version 120

varying vec3 tintColor;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

void main() {
    gl_Position = ftransform();
    tintColor = gl_Color.rgb;

    vec4 position = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;
    gl_Position = gl_ProjectionMatrix * gbufferModelView * position;
}