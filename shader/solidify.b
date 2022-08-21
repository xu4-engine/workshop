; Approximate U4 title fade-in
; https://www.shadertoy.com/view/MdGfDz - Blue Noise Dissolve
; https://www.shadertoy.com/view/lsjSRK - DIGITAL BURN FADE

tech-sh: make shader! [
    vertex {
#version 310 es
layout(location = 0) uniform mat4 transform;
layout(location = 0) in vec3 position;
out vec4 vpos;
void main() {
    // Compute light vectors in world space.
    vpos = vec4(position, 1.0);
    gl_Position = transform * vec4(position, 1.0);
}
    }

    fragment {
#version 310 es
precision mediump float;

uniform sampler2D title;
uniform sampler2D noise;
uniform float time;
uniform int frame;

in vec4 vpos;
out vec4 fragColor;

vec3 burn(vec3 col, float t)
{
    float grey = (col.r + col.g + col.b) / 3.0;
    vec3 th = vec3(cos(t), cos(t + 0.1), cos(t - 0.1)) * 0.5 + 0.5;
    if (grey > th.z)
        col = vec3(0.0, 1.0, 0.0);
    if (grey > th.y)
        col = vec3(0.0, 1.0, 1.0);
    if (grey > th.x)
        col = vec3(0.0);
    return col;
}

void main()
{
    const float PI = 3.14159265358;
    const float goldenRatioConjugate = 0.61803398875;

    vec3 bg = texture(title, vpos.st).rgb;

#if 0
    float t20 = time * 0.2;
    float t10 = time * 0.1;
    float nt = vpos.t; // * 3.0;
    float solid = texture(noise, vec2(vpos.s, nt + t10)).r +
                  texture(noise, vec2(vpos.s + t20, nt)).b * 0.5;
    vec3 color = bg * step(solid, time * 0.3);
#endif

#if 0
    float qt = time * 0.25;     // Four second fade-in.
    float solid = max(0.0, 1.0 - qt * qt);
    float noise = texture(noise, vpos.st * vec2(1.0, 2.0)).r;
    //noise = fract(noise + mod(time * 5.0, 64.0) * goldenRatioConjugate);
    noise = fract(noise + float(frame % 64) * goldenRatioConjugate);
    vec3 color = mix(vec3(0.0), bg, step(solid, noise));
#endif

#if 0
    float st = time * 3.14159265358;
    vec3 color = burn(bg, st);
#endif

#if 1
    float st = time * 0.25;     // Four second duration.
    float solid = max(0.0, 1.0 - st*st);

    // PI to 0.0 over duration.
    bg = burn(bg, (1.0 - min(1.0, st)) * PI);
    //vec3 color = bg;

    float noise = texture(noise, vpos.st * vec2(1.0, 2.0)).r;
    noise = fract(noise + float(frame % 64) * goldenRatioConjugate);
    vec3 color = mix(vec3(0.0), bg, step(solid, noise));
#endif

    fragColor = vec4(color, 1.0);
}
}
    default [
        time: 0.0
        title: load-texture %intro-0858.png
       ;noise: load-texture %noise_2d.png
       ;noise: make texture! reduce [load-image %noise_2d.png 'nearest]
        noise: make texture! reduce [load-image %LDR_RGBA_0.png 'nearest]
    ]
]

demo-widgets bind [
    overlay vbox 0,0,0,0,8 [
        button "Reset" [t: 0.0]
       ;slider 0.0,4.0 0.0 [time: value]
    ]
] tech-sh

ortho-cam: make camera [
    fov: 0.0,1.0
    clip: -1.0,1.0
]

;clear-color 0.5

t: 0.0
f: 0
;demo-exec
 demo-exec/update
    draw-list [
    clear
    (
       ;tech-sh/camera_pos: to-vec3 skip view-cam/orient 12
        tech-sh/time: t: add t rclock-delta
        tech-sh/frame: ++ f
    )
    camera ortho-cam
   ;camera view-cam
    cull on
    shader tech-sh
    buffer [vertex] #[-1.0 -1.0  0.0    1.0 -1.0  0.0
                       1.0  1.0  0.0   -1.0  1.0  0.0]
    quads 4
]

;eof
