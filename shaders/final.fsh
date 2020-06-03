#version 120

varying vec4 texcoord;

uniform sampler2D gcolor;

// Basic vignette filter
void Vignette(inout vec3 color) {

    float dist = distance(texcoord.st, vec2(0.5)) * 2.0;

    dist /= 1.5142f;

    dist = pow(dist, 1.1);

    color.rgb *= (1.0f - dist);

}

// Simple HDR conversion
vec3 convertToHDR(in vec3 color) {

    vec3 HDRImage;

    vec3 overExposed = color * 1.2;
    vec3 underExposed = color / 1.5;

    HDRImage = mix(underExposed, overExposed, color);

    return HDRImage;
}

// Modify exposure of the scene
vec3 getExposure(in vec3 color) {

    vec3 retColor;
    color *= 1.0;
    retColor = color;

    return retColor;

}

// TONEMAPS

vec3 Reignhard(in vec3 color) {

    color = color/(1.0 + color);
    return pow(color, vec3(1.0 / 2.2));

}

vec3 ReignhardAlt(in vec3 color) {
    return color/(1.0 + color);
}

vec3 Burgess(in vec3 color) {

    vec3 maxColor = max(vec3(0.0), color - 0.004);
    vec3 retColor = (maxColor * (6.2 * maxColor + 0.05)) / (maxColor * (6.2 * maxColor + 2.3) + 0.06);

    return pow(retColor, vec3(1 / 2.2));

}

// Various floats for Uncharted 2 Tonemap
float A = 0.15;
float B = 0.50;
float C = 0.10;
float D = 0.20;
float E = 0.02;
float F = 0.30;
float W = 11.2;

vec3 Uncharted2Math(in vec3 x) {

    return ((x * (A * x + C * B) + D * E) / (x * ( A * x + B) + D * F)) - E / F;

}

vec3 Uncharted2Tonemap(in vec3 color) {

    vec3 retColor;
    float exposureBias = 2.0;

    vec3 curr = Uncharted2Math(exposureBias * color);

    vec3 whiteScale = 1.0 / Uncharted2Math(vec3(W));

    retColor = curr * whiteScale;

    return pow(retColor, vec3(1 / 2.2));

}

//END TONEMAPS

void main() {

    // Parse color
    vec3 color = texture2D(gcolor, texcoord.st).rgb;

    // Apply filters
    color = convertToHDR(color);
    color = getExposure(color);

    // Apply tonemap
    color = Reignhard(color);
    //color = ReignhardAlt(color);
    //color = Burgess(color);
    //color = Uncharted2Tonemap(color);

    // Output color to screen
    gl_FragColor = vec4(color, 1.0f);

}