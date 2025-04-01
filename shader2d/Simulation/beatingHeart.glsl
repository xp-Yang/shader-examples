#include "../common.glsl"

mat2 ratate2D(float angle) {
    return mat2(
        cos(angle),  sin(angle), // 第一列（x轴方向）
        -sin(angle), cos(angle)  // 第二列（y轴方向）
    );
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 normalizedCoord = normalizeST(fragCoord);
    float currentTime = iTime;
    
    // 效果参数初始化
    vec2 currentPosition = normalizedCoord;    // 当前处理位置
    vec2 layerOffset = vec2(0.0);              // 图层偏移量
    vec2 glowDirection = vec2(0.0);            // 光晕方向累积
    float brightness = 0.0;                    // 亮度累积
    float scaleFactor = 5.0;                   // 初始缩放系数
    
    // 固定角度旋转矩阵（约286度，产生明显旋转效果）
    mat2 baseRotation = ratate2D(5.0); 

    // 分层渲染循环：共30层叠加
    for(int layerIndex = 0; layerIndex < 30; layerIndex++) {
        // 应用基础旋转
        currentPosition *= baseRotation;
        layerOffset *= baseRotation;
        
        // 生成动态参数：结合位置、时间、偏移和波动
        vec2 dynamicParams = currentPosition * scaleFactor          // 缩放后的位置
                           + float(layerIndex)                      // 图层索引影响相位
                           + layerOffset                             // 累积偏移量
                           + currentTime * 4.0                       // 时间推移
                           + sin(currentTime * 4.0) * 0.8;           // 时间波动
        
        // 亮度计算：余弦波产生明暗变化，缩放系数控制权重
        brightness += dot(cos(dynamicParams)/scaleFactor, vec2(1.0));
        
        // 生成分形偏移量（正弦波产生曲线变化）
        vec2 fractalOffset = sin(dynamicParams);
        layerOffset += fractalOffset;
        
        // 计算光晕方向（权重随缩放系数递减）
        glowDirection += fractalOffset / (scaleFactor + 20.0);
        
        // 缩放系数指数级增长（产生分形效果）
        scaleFactor *= 1.2;
    }

    vec3 finalColor = vec3(0.0);
    
    // 基础颜色：红色为主，亮度影响透明度
    finalColor += vec3(0.1) - vec3(brightness * 0.1);
    finalColor.r *= 5.0;  // 增强红色通道
    
    // 中心光晕：离中心越近亮度越高（限制最大亮度为0.7）
    float glowIntensity = min(0.7, 0.001 / length(glowDirection));
    finalColor += vec3(glowIntensity);
    
    // 边缘渐暗效果：距离中心越远颜色越暗
    float distanceFromCenter = dot(normalizedCoord, normalizedCoord);
    finalColor -= finalColor * distanceFromCenter * 0.7;

    fragColor = vec4(finalColor, 1.0);
}