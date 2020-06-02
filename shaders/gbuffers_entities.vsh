#version 120

varying vec3 color;
varying vec3 normal;
varying vec4 texcoord;
varying vec2 lmcoord;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

void main() {
    texcoord = gl_MultiTexCoord0;
    color = gl_Color.rgb;
    normal = normalize(gl_NormalMatrix * gl_Normal);
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

    vec4 position = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;

    gl_Position = gl_ProjectionMatrix * gbufferModelView * position;
}