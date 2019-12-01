// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Learn/Chapter 6/Diffcuse Vertex-Level"
{
	//逐顶点的漫反射光照效果 
    Properties
    {
		//初始值设定为白色
        _Diffcuse ("Diffcuse", Color) = (1, 1, 1, 1)
    }
    SubShader
    {

        Pass
        {
			//LightMode 定义了Pass在Unity的光照流水线中的角色
			//需要用LightMode得到Unity内置的光照变量
			Tags { "LightMode"="ForwardBase" }
            CGPROGRAM
			//pragma命令 告诉Unity我们定义的顶点着色器和片元着色器的名字
            #pragma vertex vert
            #pragma fragment frag
			//为了只用Unity的一些内置变量
            #include "Lighting.cginc"
			//这里可以得到漫反射公式里重要的参数之一 材质的漫反射属性
			fixed4 _Diffcuse;//这里的是 Properties里声明的属性 这里的定义的变量要和声明的名称一致
			//定义顶点着色器的输入和输出的结构体
			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			struct v2f{
				float4 pos : SV_POSITION;
				float3 color : COLOR;
			}

			//顶点着色器的实现
			v2f vert(a2v v){
				v2f o;
				//把模型顶点从模型空间转换到裁剪空间中
				o.pos = UnityObjectToClipPos(v.vertex);//坐标变换
				//通过内置变量UNITY_LIGHTMODEL_AMBIENT 得到光环境部分
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				//把顶点的法线转换到世界坐标下
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3) unity_WorldToObject));
				//光源方向 
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);//假设只有一个光源 这个光源是个平行光
				//saturate 归一化操作 这个函数可以把参数取值范围限制在0到1内
				//得到漫反射光的部分
				fixed3 diffcuse = _LightColor0.rgb * _Diffcuse.rgb * saturate(dot(worldNormal, worldLight));
				//环境光和漫反射光部分的叠加 得到的最终的光效果
				o.color = ambient + diffcuse;
				return o;
			}

			fixed4 frag(v2f v):SV_TARGET{
				return fixed4(v.color, 1.0);
			}
			
			FallBack "Diffcuse"
            ENDCG
        }
    }
}
