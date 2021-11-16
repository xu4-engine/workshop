; Flag shader

tech-sh: make shader! [
    vertex {
#version 310 es
layout(location = 0) uniform mat4 transform;
layout(location = 0) in vec3 position;
void main() {
    gl_Position = transform * vec4(position, 1.0);
}
    }

    fragment {
#version 310 es
precision highp float;

uniform vec3      in_res;       // viewport resolution (in pixels)
uniform float     in_time;      // shader playback time (in seconds)
uniform sampler2D noise_tex;
out vec4 fragColor;

float noise(vec2 p) {
    p *= 0.04;
    float f = texture(noise_tex, p).r + texture(noise_tex, p*2.0).g * 0.5;
    return clamp(f*f*f*0.7, 0.0, 1.0);
}

float sdBox(vec2 p, vec2 b) {
    p = abs(p) - b;
    return length(max(p, 0.0)) + min(0.0, max(p.x, p.y));
}

float sdCircle(vec2 p, float r) {
    return length(p) - r;
}

#define fillDraw(dist, col) color = mix(col, color, step(0.0, dist))
#define TIME in_time

vec4 flag(vec2 p) {
    const vec3 flagColor = vec3(1.0, 0.2, 0.2);
    const vec3 stripeCol = vec3(1.0, 1.0, 0.0);
    const vec2 flagSize = vec2(0.5, 0.5);
    vec3 color = vec3(0.0);

    p = p * 2.0 - 1.0;              // Unit view -1.0 to 1.0
    vec2 fp = p - vec2(0.5, 0.0);   // Flag position with pole at 0.0 X.

    // Shear with a waving motion.
    float wave = sin(4.0 * (p.x - TIME));
    wave += noise(vec2(p.x - TIME * 1.3, p.y) * 0.8) * 1.0;
    fp.y += 0.1 * p.x * wave;
    //fp.y += 0.2 + p.x;          // Droop

    // Shadow the wave ripples.
    float shadow = 0.4 * wave;
    shadow *= shadow;

    // Flag Background
    fillDraw(sdBox(fp, flagSize), flagColor - shadow);

    // Flag Details
    fillDraw(sdBox(fp + vec2(0.0,0.45), vec2(0.5,0.05)), stripeCol - shadow);
    fillDraw(sdBox(fp - vec2(0.0,0.40), vec2(0.5,0.05)), stripeCol - shadow);
    fillDraw(sdCircle(fp, 0.2), vec3(1.0) - shadow);

    return vec4(color, 1.0);
}

void main()
{
    fragColor = flag(gl_FragCoord.xy / in_res.xy);
}
}
    default [
        in_res: 256.0, 256.0
        in_time: 0.0
        noise_tex: load-texture %noise_2d.png
    ]
]

ortho-cam: make camera [
    fov: -1.0,1.0
    clip: -1.0,1.0
]

t: 0.0
demo-exec
;demo-exec/update
    draw-list [
    clear
    (
        tech-sh/in_time: t: add t rclock-delta
        tech-sh/in_res: to-vec3 slice view-cam/viewport 2,2
    )
    camera ortho-cam
    cull on
    shader tech-sh
    buffer [vertex] #[-1.0 -1.0 -1.0    1.0 -1.0 -1.0
					   1.0  1.0 -1.0   -1.0  1.0 -1.0]
    quads 4
]

;eof
