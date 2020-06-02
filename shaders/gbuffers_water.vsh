#version 120

varying vec3 color;
varying vec3 normal;
varying vec4 texcoord;
varying vec4 lmcoord;
varying float water;
varying float ice;
varying float stainedGlass;
varying float stainedGlassPlane;
varying float netherPortal;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

attribute vec4 mc_Entity;

void main() {
    vec4 position = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;
    gl_Position = gl_ProjectionMatrix * gbufferModelView * position;
    texcoord = gl_MultiTexCoord0;
    lmcoord = gl_MultiTexCoord1;
    color = gl_Color.rgb;
    normal = normalize(gl_NormalMatrix * gl_Normal);

    water = 0.0;
    ice = 0.0;
    stainedGlass = 0.0;
    stainedGlassPlane = 0.0;
    netherPortal = 0.0;

    if (mc_Entity.x == 8.0 || mc_Entity.x == 9.0) water = 1.0;
    if (mc_Entity.x == 79.0) ice = 1.0;
    if (mc_Entity.x == 90.0) netherPortal = 1.0;
    if (mc_Entity.x == 95.0) stainedGlass = 1.0;
    if (mc_Entity.x == 160.0) stainedGlassPlane = 1.0;
}