attribute vec4 Position;
attribute vec2 UV;
attribute float Convex;
attribute float Filled;

/// [-1, 1]
varying vec3 screenSpacePosition;
varying vec2 DestinationUV;
varying float _Convex;
varying float _Filled;

void main(void) {
    
    _Convex = Convex;
    _Filled = Filled;
    
    DestinationUV = UV;
    
    gl_Position = Position;
    
    screenSpacePosition = gl_Position.xyz / gl_Position.w; //perspective divide/normalize
}