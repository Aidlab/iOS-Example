varying lowp vec2 DestinationUV;
varying lowp float _Convex;
varying lowp float _Filled;
varying lowp vec3 screenSpacePosition;

void main(void) {
    
    lowp float t = 0.0;
    
    if( _Filled < 0.5 ) {
        
        if( _Convex < 0.5 ) {
            
            t = (DestinationUV.x * DestinationUV.x - DestinationUV.y);
            
            if (t < 0.0)
                discard;
        }
        
    } else if( _Convex < 0.5 ) {
        
        t = -(DestinationUV.x * DestinationUV.x - DestinationUV.y);
        
        if (t < 0.0)
            discard;
    }
    
    /// screenSpacePosition is -1 to 1 in GL. Scale for 0 to 1
    lowp vec2 normalizedScreenSpacePosition = screenSpacePosition.xy * 0.5 + 0.5;
    
    /// Create gradient effect
    lowp vec3 outColor = mix( vec3(254.0, 214.0, 222.0), vec3(255.0, 125.0, 148.0), normalizedScreenSpacePosition.y);
    
    gl_FragColor = vec4(outColor.r/255.0, outColor.g/255.0, outColor.b/255.0, 1);
}