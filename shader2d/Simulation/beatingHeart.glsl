#include "../common.glsl"

mat2 ratate2D(float angle) {
    return mat2(
        cos(angle),  sin(angle), // ��һ�У�x�᷽��
        -sin(angle), cos(angle)  // �ڶ��У�y�᷽��
    );
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 normalizedCoord = normalizeST(fragCoord);
    float currentTime = iTime;
    
    // Ч��������ʼ��
    vec2 currentPosition = normalizedCoord;    // ��ǰ����λ��
    vec2 layerOffset = vec2(0.0);              // ͼ��ƫ����
    vec2 glowDirection = vec2(0.0);            // ���η����ۻ�
    float brightness = 0.0;                    // �����ۻ�
    float scaleFactor = 5.0;                   // ��ʼ����ϵ��
    
    // �̶��Ƕ���ת����Լ286�ȣ�����������תЧ����
    mat2 baseRotation = ratate2D(5.0); 

    // �ֲ���Ⱦѭ������30�����
    for(int layerIndex = 0; layerIndex < 30; layerIndex++) {
        // Ӧ�û�����ת
        currentPosition *= baseRotation;
        layerOffset *= baseRotation;
        
        // ���ɶ�̬���������λ�á�ʱ�䡢ƫ�ƺͲ���
        vec2 dynamicParams = currentPosition * scaleFactor          // ���ź��λ��
                           + float(layerIndex)                      // ͼ������Ӱ����λ
                           + layerOffset                             // �ۻ�ƫ����
                           + currentTime * 4.0                       // ʱ������
                           + sin(currentTime * 4.0) * 0.8;           // ʱ�䲨��
        
        // ���ȼ��㣺���Ҳ����������仯������ϵ������Ȩ��
        brightness += dot(cos(dynamicParams)/scaleFactor, vec2(1.0));
        
        // ���ɷ���ƫ���������Ҳ��������߱仯��
        vec2 fractalOffset = sin(dynamicParams);
        layerOffset += fractalOffset;
        
        // ������η���Ȩ��������ϵ���ݼ���
        glowDirection += fractalOffset / (scaleFactor + 20.0);
        
        // ����ϵ��ָ������������������Ч����
        scaleFactor *= 1.2;
    }

    vec3 finalColor = vec3(0.0);
    
    // ������ɫ����ɫΪ��������Ӱ��͸����
    finalColor += vec3(0.1) - vec3(brightness * 0.1);
    finalColor.r *= 5.0;  // ��ǿ��ɫͨ��
    
    // ���Ĺ��Σ�������Խ������Խ�ߣ������������Ϊ0.7��
    float glowIntensity = min(0.7, 0.001 / length(glowDirection));
    finalColor += vec3(glowIntensity);
    
    // ��Ե����Ч������������ԽԶ��ɫԽ��
    float distanceFromCenter = dot(normalizedCoord, normalizedCoord);
    finalColor -= finalColor * distanceFromCenter * 0.7;

    fragColor = vec4(finalColor, 1.0);
}