#version 120

#include "/lib/framebuffer.glsl"

const int noiseTextureResolution = 64;

varying vec3 lightVector;
varying vec3 lightColor;
varying vec3 skyColor;

uniform sampler2D gdepthtex;
uniform sampler2D shadow;

uniform float viewWidth;
uniform float viewHeight;

uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

varying vec4 texcoord;

/* DRAWBUFFERS : 012 */

struct Fragment {
    vec3 albedo;
    vec3 normal;
    float emission;
};

struct LightMap {
    float torchLightStrength;
    float skyLightStrength;
};

//SHADOW STUFF

float getDepth(in vec2 coord) {
    return texture2D(gdepthtex, coord).r;
}

vec4 getCameraSpacePosition(in vec2 coord) {
    float depth = getDepth(coord);
    vec4 positionNdcSpace = vec4(coord.s * 2.0 - 1.0, coord.t * 2.0 - 1.0, 2.0 * depth - 1.0, 1.0);
    vec4 positionCameraSpace = gbufferProjectionInverse * positionNdcSpace;
    return positionCameraSpace / positionCameraSpace.w;
}

vec4 getWorldSpacePosition(in vec2 coord) {
    vec4 positionCameraSpace = getCameraSpacePosition(coord);
    vec4 positionWorldSpace = gbufferModelViewInverse * positionCameraSpace;
    positionWorldSpace.xyz += cameraPosition.xyz;
    return positionWorldSpace;
}

vec3 getShadowSpacePosition(in vec2 coord) {
    vec4 positionWorldSpace = getWorldSpacePosition(coord);
    positionWorldSpace.xyz -= cameraPosition;
    vec4 positionShadowSpace = shadowModelView * positionWorldSpace;
    positionShadowSpace = shadowProjection * positionShadowSpace;
    positionShadowSpace /= positionShadowSpace.w;

    return positionShadowSpace.xyz * 0.5 + 0.5;
}

float getSunVisibility(in vec2 coord) {
    vec3 positionShadowSpace = getShadowSpacePosition(coord);
    float shadowMapSample = texture2D(shadow, positionShadowSpace.st).r;
    return step(positionShadowSpace.z - shadowMapSample, 1.0 / shadowMapResolution);
}

vec3 calculateLitSurface(in vec3 color) {
    float sunVisibility = getSunVisibility(texcoord.st);
    float ambientLighting = 0.3;
    return color * (sunVisibility + ambientLighting);
}

//END SHADOW STUFF

// Parse into Fragment
Fragment getFragment(in vec2 coord) {
    Fragment newFragment;
    newFragment.albedo = getAlbedo(coord);
    newFragment.normal = getNormal(coord);
    newFragment.emission = getEmission(coord);
    return newFragment;
}

// Parse into Light Map
LightMap getLightMapSample(in vec2 coord) {
    LightMap newLightMap;
    newLightMap.torchLightStrength = getTorchLightStrength(coord);
    newLightMap.skyLightStrength = getSkyLightStrength(coord);
    
    return newLightMap;
}

// Calculate the lighting of the scene
vec3 calculateLighting(in Fragment frag, in LightMap lightmap) {

    // Calculate the amount a surface should be lit
    float directLightStrength = dot(frag.normal, lightVector);
    directLightStrength = max(0.0, directLightStrength);
    vec3 directLight = directLightStrength * lightColor;
    directLight = calculateLitSurface(directLight); // add shadows
    
    // Define torch color
    vec3 torchColor = vec3(1.0, 0.8, 0.3) * 0.1;
    vec3 torchLight = torchColor * lightmap.torchLightStrength;

    // Parse sky color into a light value
    vec3 skyLight = skyColor * lightmap.skyLightStrength;

    // Mix the fragments albedo with the various light modifiers and sources
    vec3 litColor = frag.albedo * (directLight + skyLight + torchLight);
    return litColor;
    //return mix(litColor, frag.albedo, frag.emission);
}

void main() {

    // Parse texcoords into a Fragment and a Lightmap
    Fragment frag = getFragment(texcoord.st);
    LightMap lightmap = getLightMapSample(texcoord.st);

    // Calculate the lighting
    vec3 finalColor = calculateLighting(frag, lightmap);

    // Output final product
    GCOLOR_OUT = vec4(finalColor, 1.0);
}