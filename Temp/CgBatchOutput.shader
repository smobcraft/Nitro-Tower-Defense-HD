Shader "Transparent/Navmesh/TransparentAlwaysShow" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,0.5)
    _MainTex ("Texture", 2D) = "white" { }
    _Scale ("Scale", float) = 1
    _FadeColor ("Fade Color", Color) = (1,1,1,0.3)
}
SubShader {
	
	Pass {
   		ColorMask 0
   	}
	
	Tags {"Queue"="Transparent+1" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 200
	
	
	
	Offset 0, -20
	Cull Off
	Lighting On
	
	Pass {
		ZWrite Off
		ZTest Greater
		Blend SrcAlpha OneMinusSrcAlpha
		
		Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 9 to 9
//   d3d9 - ALU: 9 to 9
//   d3d11 - ALU: 10 to 10, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 10 to 10, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "color" Color
Matrix 5 [_Object2World]
Float 9 [_Scale]
Vector 10 [_FadeColor]
"!!ARBvp1.0
# 9 ALU
PARAM c[11] = { program.local[0],
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
DP4 R0.y, vertex.position, c[5];
DP4 R0.x, vertex.position, c[7];
MUL result.color, vertex.color, c[10];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
MUL result.texcoord[0].x, R0.y, c[9];
MUL result.texcoord[0].y, R0.x, c[9].x;
END
# 9 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Float 8 [_Scale]
Vector 9 [_FadeColor]
"vs_2_0
; 9 ALU
dcl_position0 v0
dcl_color0 v1
dp4 r0.y, v0, c4
dp4 r0.x, v0, c6
mul oD0, v1, c9
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
mul oT0.x, r0.y, c8
mul oT0.y, r0.x, c8.x
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 64 // 48 used size, 4 vars
Float 16 [_Scale]
Vector 32 [_FadeColor] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 1 temp regs, 0 temp arrays:
// ALU 10 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedmdpfcgccjlhpiidhoclpeglkkkcjokedabaaaaaanmacaaaaadaaaaaa
cmaaaaaahmaaaaaapaaaaaaaejfdeheoeiaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaafaepfdejfeejepeoaaedepemepfcaaklepfdeheo
gmaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaagfaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklfdeieefcoeabaaaaeaaaabaahjaaaaaa
fjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaaaaaeegiocaaaabaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaidcaabaaaaaaaaaaafgbfbaaaaaaaaaaaigiacaaaabaaaaaaanaaaaaa
dcaaaaakdcaabaaaaaaaaaaaigiacaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaa
egaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaabaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaa
abaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaabaaaaaaaaaaadiaaaaaidccabaaa
abaaaaaaegaabaaaaaaaaaaaagiacaaaaaaaaaaaabaaaaaadiaaaaaipccabaaa
acaaaaaaegbobaaaabaaaaaaegiocaaaaaaaaaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying mediump vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _FadeColor;
uniform highp float _Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex);
  highp vec2 tmpvar_3;
  tmpvar_3.x = (tmpvar_2.x * _Scale);
  tmpvar_3.y = (tmpvar_2.z * _Scale);
  highp vec4 tmpvar_4;
  tmpvar_4 = (_glesColor * _FadeColor);
  tmpvar_1 = tmpvar_4;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_COLOR = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying mediump vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0);
  gl_FragData[0] = (tmpvar_1 * xlv_COLOR);
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying mediump vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _FadeColor;
uniform highp float _Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex);
  highp vec2 tmpvar_3;
  tmpvar_3.x = (tmpvar_2.x * _Scale);
  tmpvar_3.y = (tmpvar_2.z * _Scale);
  highp vec4 tmpvar_4;
  tmpvar_4 = (_glesColor * _FadeColor);
  tmpvar_1 = tmpvar_4;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_COLOR = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying mediump vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0);
  gl_FragData[0] = (tmpvar_1 * xlv_COLOR);
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Float 8 [_Scale]
Vector 9 [_FadeColor]
"agal_vs
[bc]
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.y, a0, c4
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.x, a0, c6
adaaaaaaahaaapaeacaaaaoeaaaaaaaaajaaaaoeabaaaaaa mul v7, a2, c9
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
adaaaaaaaaaaabaeaaaaaaffacaaaaaaaiaaaaoeabaaaaaa mul v0.x, r0.y, c8
adaaaaaaaaaaacaeaaaaaaaaacaaaaaaaiaaaaaaabaaaaaa mul v0.y, r0.x, c8.x
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 64 // 48 used size, 4 vars
Float 16 [_Scale]
Vector 32 [_FadeColor] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 1 temp regs, 0 temp arrays:
// ALU 10 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedhdlhfnblkmamihooohcpiggnloiddpekabaaaaaacmaeaaaaaeaaaaaa
daaaaaaahmabaaaagiadaaaaliadaaaaebgpgodjeeabaaaaeeabaaaaaaacpopp
piaaaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaabaa
acaaabaaaaaaaaaaabaaaaaaaeaaadaaaaaaaaaaabaaamaaaeaaahaaaaaaaaaa
aaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
afaaaaadaaaaadiaaaaaffjaaiaaoikaaeaaaaaeaaaaadiaahaaoikaaaaaaaja
aaaaoeiaaeaaaaaeaaaaadiaajaaoikaaaaakkjaaaaaoeiaaeaaaaaeaaaaadia
akaaoikaaaaappjaaaaaoeiaafaaaaadaaaaadoaaaaaoeiaabaaaakaafaaaaad
abaaapoaabaaoejaacaaoekaafaaaaadaaaaapiaaaaaffjaaeaaoekaaeaaaaae
aaaaapiaadaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadma
aaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefc
oeabaaaaeaaaabaahjaaaaaafjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaaaaae
egiocaaaabaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaa
abaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaa
gfaaaaadpccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
igiacaaaabaaaaaaanaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaabaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaa
igiacaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaak
dcaabaaaaaaaaaaaigiacaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaabaaa
aaaaaaaadiaaaaaidccabaaaabaaaaaaegaabaaaaaaaaaaaagiacaaaaaaaaaaa
abaaaaaadiaaaaaipccabaaaacaaaaaaegbobaaaabaaaaaaegiocaaaaaaaaaaa
acaaaaaadoaaaaabejfdeheoeiaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapapaaaafaepfdejfeejepeoaaedepemepfcaaklepfdeheogmaaaaaa
adaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaagfaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaedepemepfcaakl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 324
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    mediump vec4 col;
};
#line 318
struct appdata_color {
    highp vec4 vertex;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform sampler2D _MainTex;
uniform highp float _Scale;
uniform highp vec4 _FadeColor;
#line 331
uniform highp vec4 _MainTex_ST;
#line 332
v2f vert( in appdata_color v ) {
    v2f o;
    #line 335
    o.pos = (glstate_matrix_mvp * v.vertex);
    highp vec4 worldSpace = (_Object2World * v.vertex);
    o.uv = vec2( (worldSpace.x * _Scale), (worldSpace.z * _Scale));
    o.col = (v.color * _FadeColor);
    #line 339
    return o;
}
out highp vec2 xlv_TEXCOORD0;
out mediump vec4 xlv_COLOR;
void main() {
    v2f xl_retval;
    appdata_color xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.uv);
    xlv_COLOR = vec4(xl_retval.col);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 324
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    mediump vec4 col;
};
#line 318
struct appdata_color {
    highp vec4 vertex;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform sampler2D _MainTex;
uniform highp float _Scale;
uniform highp vec4 _FadeColor;
#line 331
uniform highp vec4 _MainTex_ST;
#line 341
mediump vec4 frag( in v2f i ) {
    #line 343
    mediump vec4 texcol = (texture( _MainTex, i.uv) * i.col);
    return texcol;
}
in highp vec2 xlv_TEXCOORD0;
in mediump vec4 xlv_COLOR;
void main() {
    mediump vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.col = vec4(xlv_COLOR);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 2 to 2, TEX: 1 to 1
//   d3d9 - ALU: 2 to 2, TEX: 1 to 1
//   d3d11 - ALU: 1 to 1, TEX: 1 to 1, FLOW: 1 to 1
//   d3d11_9x - ALU: 1 to 1, TEX: 1 to 1, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
# 2 ALU, 1 TEX
TEMP R0;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL result.color, R0, fragment.color.primary;
END
# 2 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 2 ALU, 1 TEX
dcl_2d s0
dcl t0.xy
dcl v0
texld r0, t0, s0
mul r0, r0, v0
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { }
SetTexture 0 [_MainTex] 2D 0
// 3 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedfegaioofmmicpkbficfbjgebinnhpaagabaaaaaahaabaaaaadaaaaaa
cmaaaaaakaaaaaaaneaaaaaaejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaagfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaakl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcjeaaaaaaeaaaaaaa
cfaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacabaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahpccabaaaaaaaaaaaegaobaaa
aaaaaaaaegbobaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "flash " {
Keywords { }
SetTexture 0 [_MainTex] 2D
"agal_ps
[bc]
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v0, s0 <2d wrap linear point>
adaaaaaaaaaaapacaaaaaaoeacaaaaaaahaaaaoeaeaaaaaa mul r0, r0, v7
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { }
SetTexture 0 [_MainTex] 2D 0
// 3 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedolbdkddgfjgolfckbgpbmlkcmidflklfabaaaaaapmabaaaaaeaaaaaa
daaaaaaaliaaaaaafeabaaaamiabaaaaebgpgodjiaaaaaaaiaaaaaaaaaacpppp
fiaaaaaaciaaaaaaaaaaciaaaaaaciaaaaaaciaaabaaceaaaaaaciaaaaaaaaaa
aaacppppbpaaaaacaaaaaaiaaaaaadlabpaaaaacaaaaaaiaabaaaplabpaaaaac
aaaaaajaaaaiapkaecaaaaadaaaaapiaaaaaoelaaaaioekaafaaaaadaaaacpia
aaaaoeiaabaaoelaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcjeaaaaaa
eaaaaaaacfaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacabaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahpccabaaaaaaaaaaa
egaobaaaaaaaaaaaegbobaaaacaaaaaadoaaaaabejfdeheogmaaaaaaadaaaaaa
aiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaagfaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3"
}

}

#LINE 72

	
	 }
	 
	 ZWrite Off
    Pass {
		ZTest LEqual
		//Blend One One Fog { Color (0,0,0,0) }
		
		Blend SrcAlpha OneMinusSrcAlpha
		
		ZWrite Off
		
		Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 9 to 9
//   d3d9 - ALU: 9 to 9
//   d3d11 - ALU: 9 to 9, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 9 to 9, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "color" Color
Matrix 5 [_Object2World]
Float 9 [_Scale]
"!!ARBvp1.0
# 9 ALU
PARAM c[10] = { program.local[0],
		state.matrix.mvp,
		program.local[5..9] };
TEMP R0;
DP4 R0.y, vertex.position, c[5];
DP4 R0.x, vertex.position, c[7];
MOV result.color, vertex.color;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
MUL result.texcoord[0].x, R0.y, c[9];
MUL result.texcoord[0].y, R0.x, c[9].x;
END
# 9 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Float 8 [_Scale]
"vs_2_0
; 9 ALU
dcl_position0 v0
dcl_color0 v1
dp4 r0.y, v0, c4
dp4 r0.x, v0, c6
mov oD0, v1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
mul oT0.x, r0.y, c8
mul oT0.y, r0.x, c8.x
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 32 // 20 used size, 2 vars
Float 16 [_Scale]
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedfihdhaknhmnchhmagnpgnnablbkgldefabaaaaaanaacaaaaadaaaaaa
cmaaaaaahmaaaaaapaaaaaaaejfdeheoeiaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaafaepfdejfeejepeoaaedepemepfcaaklepfdeheo
gmaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaagfaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaedepemepfcaaklfdeieefcniabaaaaeaaaabaahgaaaaaa
fjaaaaaeegiocaaaaaaaaaaaacaaaaaafjaaaaaeegiocaaaabaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaidcaabaaaaaaaaaaafgbfbaaaaaaaaaaaigiacaaaabaaaaaaanaaaaaa
dcaaaaakdcaabaaaaaaaaaaaigiacaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaa
egaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaabaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaa
abaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaabaaaaaaaaaaadiaaaaaidccabaaa
abaaaaaaegaabaaaaaaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaafpccabaaa
acaaaaaaegbobaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying mediump vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (_Object2World * _glesVertex);
  highp vec2 tmpvar_2;
  tmpvar_2.x = (tmpvar_1.x * _Scale);
  tmpvar_2.y = (tmpvar_1.z * _Scale);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR = _glesColor;
}



#endif
#ifdef FRAGMENT

varying mediump vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0);
  gl_FragData[0] = (tmpvar_1 * xlv_COLOR);
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying mediump vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (_Object2World * _glesVertex);
  highp vec2 tmpvar_2;
  tmpvar_2.x = (tmpvar_1.x * _Scale);
  tmpvar_2.y = (tmpvar_1.z * _Scale);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR = _glesColor;
}



#endif
#ifdef FRAGMENT

varying mediump vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0);
  gl_FragData[0] = (tmpvar_1 * xlv_COLOR);
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Float 8 [_Scale]
"agal_vs
[bc]
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.y, a0, c4
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.x, a0, c6
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
adaaaaaaaaaaabaeaaaaaaffacaaaaaaaiaaaaoeabaaaaaa mul v0.x, r0.y, c8
adaaaaaaaaaaacaeaaaaaaaaacaaaaaaaiaaaaaaabaaaaaa mul v0.y, r0.x, c8.x
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 32 // 20 used size, 2 vars
Float 16 [_Scale]
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedkehdmclemdacinkjmejfamogofhfhdcbabaaaaaabmaeaaaaaeaaaaaa
daaaaaaahiabaaaafiadaaaakiadaaaaebgpgodjeaabaaaaeaabaaaaaaacpopp
peaaaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaabaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaaeaaagaaaaaaaaaa
aaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
afaaaaadaaaaadiaaaaaffjaahaaoikaaeaaaaaeaaaaadiaagaaoikaaaaaaaja
aaaaoeiaaeaaaaaeaaaaadiaaiaaoikaaaaakkjaaaaaoeiaaeaaaaaeaaaaadia
ajaaoikaaaaappjaaaaaoeiaafaaaaadaaaaadoaaaaaoeiaabaaaakaafaaaaad
aaaaapiaaaaaffjaadaaoekaaeaaaaaeaaaaapiaacaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiaaeaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaafaaoeka
aaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiaabaaaaacabaaapoaabaaoejappppaaaafdeieefcniabaaaa
eaaaabaahgaaaaaafjaaaaaeegiocaaaaaaaaaaaacaaaaaafjaaaaaeegiocaaa
abaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
pccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaidcaabaaaaaaaaaaafgbfbaaaaaaaaaaaigiacaaa
abaaaaaaanaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaaabaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdcaabaaaaaaaaaaaigiacaaa
abaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdcaabaaa
aaaaaaaaigiacaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaabaaaaaaaaaaa
diaaaaaidccabaaaabaaaaaaegaabaaaaaaaaaaaagiacaaaaaaaaaaaabaaaaaa
dgaaaaafpccabaaaacaaaaaaegbobaaaabaaaaaadoaaaaabejfdeheoeiaaaaaa
acaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaa
ebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaafaepfdejfeejepeo
aaedepemepfcaaklepfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaadamaaaagfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaakl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 323
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    mediump vec4 col;
};
#line 317
struct appdata_color {
    highp vec4 vertex;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform sampler2D _MainTex;
uniform highp float _Scale;
#line 330
#line 339
#line 330
v2f vert( in appdata_color v ) {
    v2f o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 334
    highp vec4 worldSpace = (_Object2World * v.vertex);
    o.uv = vec2( (worldSpace.x * _Scale), (worldSpace.z * _Scale));
    o.col = v.color;
    return o;
}
out highp vec2 xlv_TEXCOORD0;
out mediump vec4 xlv_COLOR;
void main() {
    v2f xl_retval;
    appdata_color xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.uv);
    xlv_COLOR = vec4(xl_retval.col);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 323
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    mediump vec4 col;
};
#line 317
struct appdata_color {
    highp vec4 vertex;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform sampler2D _MainTex;
uniform highp float _Scale;
#line 330
#line 339
#line 339
mediump vec4 frag( in v2f i ) {
    mediump vec4 texcol = (texture( _MainTex, i.uv) * i.col);
    return texcol;
}
in highp vec2 xlv_TEXCOORD0;
in mediump vec4 xlv_COLOR;
void main() {
    mediump vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.col = vec4(xlv_COLOR);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 2 to 2, TEX: 1 to 1
//   d3d9 - ALU: 2 to 2, TEX: 1 to 1
//   d3d11 - ALU: 1 to 1, TEX: 1 to 1, FLOW: 1 to 1
//   d3d11_9x - ALU: 1 to 1, TEX: 1 to 1, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
# 2 ALU, 1 TEX
TEMP R0;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL result.color, R0, fragment.color.primary;
END
# 2 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 2 ALU, 1 TEX
dcl_2d s0
dcl t0.xy
dcl v0
texld r0, t0, s0
mul r0, r0, v0
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { }
SetTexture 0 [_MainTex] 2D 0
// 3 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedfegaioofmmicpkbficfbjgebinnhpaagabaaaaaahaabaaaaadaaaaaa
cmaaaaaakaaaaaaaneaaaaaaejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaagfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaakl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcjeaaaaaaeaaaaaaa
cfaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacabaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahpccabaaaaaaaaaaaegaobaaa
aaaaaaaaegbobaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "flash " {
Keywords { }
SetTexture 0 [_MainTex] 2D
"agal_ps
[bc]
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v0, s0 <2d wrap linear point>
adaaaaaaaaaaapacaaaaaaoeacaaaaaaahaaaaoeaeaaaaaa mul r0, r0, v7
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { }
SetTexture 0 [_MainTex] 2D 0
// 3 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedolbdkddgfjgolfckbgpbmlkcmidflklfabaaaaaapmabaaaaaeaaaaaa
daaaaaaaliaaaaaafeabaaaamiabaaaaebgpgodjiaaaaaaaiaaaaaaaaaacpppp
fiaaaaaaciaaaaaaaaaaciaaaaaaciaaaaaaciaaabaaceaaaaaaciaaaaaaaaaa
aaacppppbpaaaaacaaaaaaiaaaaaadlabpaaaaacaaaaaaiaabaaaplabpaaaaac
aaaaaajaaaaiapkaecaaaaadaaaaapiaaaaaoelaaaaioekaafaaaaadaaaacpia
aaaaoeiaabaaoelaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcjeaaaaaa
eaaaaaaacfaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacabaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahpccabaaaaaaaaaaa
egaobaaaaaaaaaaaegbobaaaacaaaaaadoaaaaabejfdeheogmaaaaaaadaaaaaa
aiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaagfaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3"
}

}

#LINE 123

	
	    }
	
	
	}
Fallback "VertexLit"
}