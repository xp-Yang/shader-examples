// ԭ��Ʒ����Danilo Guanabara��http://www.pouet.net/prod.php?which=57245
// ��ֲ��Shadertoy��https://www.shadertoy.com/view/XsXXDn

#include "../common.glsl"

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // ��ʼ����ɫ���м����
    vec3 color = vec3(0.0);  // RGB��ɫͨ��
    float distanceToCenter = 0.0; // ���������ĵľ���
    float timeOffset = iTime;     // ʱ���׼ֵ
    
    // ѭ������3����ɫͨ�����졢�̡�����
    for(int channel = 0; channel < 3; channel++) {
        // �����׼��������������ת����[0,1]��Χ��
        vec2 uv = fragCoord.xy / iResolution.xy;
        
        // �����������Ƶ��������ģ������ֿ�߱�
        vec2 p = normalizeST(fragCoord) / 2.0;
        
        // ��ʱ��仯�Ĳ���
        timeOffset += 0.07; // ÿ����ɫͨ�����Ӳ�ͬʱ��ƫ��
        distanceToCenter = length(p); // ���㵽���ĵľ���
        
        // ���ɶ�̬UV���꣨���Ĳ������̣�
        uv += p / distanceToCenter 
            * (sin(timeOffset) + 1.0)        // ��������
            * abs(sin(distanceToCenter * 9.0 - timeOffset * 2.0)); // ���ϲ���
        
        // ������ɫǿ�ȣ�ͨ�����볡ʵ�ֹ���Ч����
        float intensity = 0.01 / length(fract(uv) - 0.5);
        
        // ��ǿ�ȷ��䵽��ǰ��ɫͨ��
        color[channel] = intensity / distanceToCenter;
    }
    
    // ���������ɫ��alphaͨ��ʹ��ʱ�䶯̬�仯��
    fragColor = vec4(color, mod(iTime, 1.0)); 
}