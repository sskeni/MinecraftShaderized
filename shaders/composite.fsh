#version 120

#include "/lib/framebuffer.glsl"

const int noiseTextureResolution = 64;

varying vec3 lightVector;
varying vec3 lightColor;
varying vec3 skyColor;

uniform sampler2D gdepthtex;
uniform sampler2D shadow;
uniform sampler2D shadowcolor0;
uniform sampler2D noisetex;

uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform float viewWidth;
uniform float viewHeight;

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
/*
// Get depth of a coordinate
float getDepth(in vec2 coord) {

    return texture2D(gdepthtex, coord).r;

}

// Get the camera position
vec4 getCameraSpacePosition(in vec2 coord) {

    float depth = getDepth(coord);
    vec4 positionNdcSpace = vec4(coord.s * 2.0 - 1.0, coord.t * 2.0 - 1.0, 2.0 * depth - 1.0, 1.0);
    vec4 positionCameraSpace = gbufferProjectionInverse * positionNdcSpace;

    return positionCameraSpace / positionCameraSpace.w;

}

// Get world space position
vec4 getWorldSpacePosition(in vec2 coord) {

    vec4 positionCameraSpace = getCameraSpacePosition(coord);
    vec4 positionWorldSpace = gbufferModelViewInverse * positionCameraSpace;
    positionWorldSpace.xyz += cameraPosition;

    return positionWorldSpace;

}

// Get shadow space coordinates
vec3 getShadowSpacePosition(in vec2 coord) {

    vec4 positionWorldSpace = getWorldSpacePosition(coord);

    positionWorldSpace.xyz -= cameraPosition;
    vec4 positionShadowSpace = shadowModelView * positionWorldSpace;
    positionShadowSpace = shadowProjection * positionShadowSpace;
    positionShadowSpace /= positionShadowSpace.w;

    return positionShadowSpace.xyz = positionShadowSpace.xyz * 0.5 + 0.5;

}

mat2 getRotationMatrix(in vec2 coord) {
    float rotationAmount = texture2D(
        noisetex,
        coord * vec2(
            viewWidth / noiseTextureResolution,
            viewHeight / noiseTextureResolution
        )
    ).r;

    return mat2(
        cos(rotationAmount), -sin(rotationAmount),
        sin(rotationAmount), cos(rotationAmount)
    );
}

// 1 - completely visible, 0 - completely blocked
vec3 getShadowColor(in vec2 coord) {

    vec3 shadowCoord = getShadowSpacePosition(coord);

    mat2 rotationMatrix = getRotationMatrix(coord);

    //vec3 shadowColor = vec3(0);
    float 
    // Sample around the shadow coordinate to fade edges
    for(int y = -1; y < 2; y++) {
        for(int x = -1; x < 2; x++) {
            vec2 offset = vec2(x, y) / shadowMapResolution;
            offset = rotationMatrix * offset;
            float shadowMapSample = texture2D(shadow, shadowCoord.st + offset).r;
            float visibility = step(shadowCoord.z - shadowMapSample, 0.005);

            // Colored Shadows
            //vec3 colorSample = texture2D(shadowcolor0, shadowCoord.st + offset).rgb;
            //shadowColor += mix(colorSample, vec3(1.0), visibility);
        }
    }

    return shadowColor * 0.111;
}

vec3 calculateLitSurface(in vec3 color) {

    vec3 sunLightAmount = getShadowColor(texcoord.st);
    vec3 ambientLighting = vec3(0.3);

    return color * (sunLightAmount + ambientLighting);

}*/

// Calculate the lighting of the scene
vec3 calculateLighting(in Fragment frag, in LightMap lightmap) {

    // Calculate the amount a surface should be lit
    float directLightStrength = dot(frag.normal, lightVector);
    directLightStrength = max(0.0, directLightStrength);
    vec3 directLight = directLightStrength * lightColor;

    // Define torch color
    vec3 torchColor = vec3(1.0, 0.8, 0.3) * 0.1;
    vec3 torchLight = torchColor * lightmap.torchLightStrength;

    // Parse sky color into a light value
    vec3 skyLight = skyColor * lightmap.skyLightStrength;

    // Mix the fragments albedo with the various light modifiers and sources
    vec3 litColor = frag.albedo * (directLight + skyLight + torchLight);
    return mix(litColor, frag.albedo, frag.emission);
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