#version 120

uniform int worldTime;
uniform vec3 sunPosition;
uniform vec3 moonPosition;

varying vec3 lightVector;
varying vec3 lightColor;
varying vec3 skyColor;

varying vec4 texcoord;

void main() {

    gl_Position = ftransform();

    texcoord = gl_MultiTexCoord0;

    float time = worldTime;

    // Change the sky values based on the time of day
    if(time < 12700 || time > 23250) {
        lightVector = normalize(sunPosition);
        lightColor = vec3(1.0);
        skyColor = vec3(0.003);
    }
    else {
        lightVector = normalize(moonPosition);
        lightColor = vec3(0.1);
        skyColor = vec3(0.0003);
    }

}