// 原作品来自Danilo Guanabara：http://www.pouet.net/prod.php?which=57245
// 移植自Shadertoy：https://www.shadertoy.com/view/XsXXDn

#include "../common.glsl"

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // 初始化颜色和中间变量
    vec3 color = vec3(0.0);  // RGB颜色通道
    float distanceToCenter = 0.0; // 到画面中心的距离
    float timeOffset = iTime;     // 时间基准值
    
    // 循环处理3个颜色通道（红、绿、蓝）
    for(int channel = 0; channel < 3; channel++) {
        // 坐标标准化（将像素坐标转换到[0,1]范围）
        vec2 uv = fragCoord.xy / iResolution.xy;
        
        // 将坐标中心移到画面中心，并保持宽高比
        vec2 p = normalizeST(fragCoord) / 2.0;
        
        // 随时间变化的参数
        timeOffset += 0.07; // 每个颜色通道增加不同时间偏移
        distanceToCenter = length(p); // 计算到中心的距离
        
        // 生成动态UV坐标（核心波动方程）
        uv += p / distanceToCenter 
            * (sin(timeOffset) + 1.0)        // 基础波动
            * abs(sin(distanceToCenter * 9.0 - timeOffset * 2.0)); // 复合波动
        
        // 计算颜色强度（通过距离场实现光晕效果）
        float intensity = 0.01 / length(fract(uv) - 0.5);
        
        // 将强度分配到当前颜色通道
        color[channel] = intensity / distanceToCenter;
    }
    
    // 组合最终颜色（alpha通道使用时间动态变化）
    fragColor = vec4(color, mod(iTime, 1.0)); 
}