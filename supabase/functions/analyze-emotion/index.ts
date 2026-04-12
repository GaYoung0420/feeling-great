import Anthropic from "npm:@anthropic-ai/sdk@0.27.0";

const EMOTION_DATA = `
감정 카테고리와 단어 목록:
- 행복감(happy): 기쁨,좋음,만족감,편안함,포근함 / 유쾌함,상쾌함,흐뭇함,즐거움,설렘 / 감탄,희열,황홀감,벅참,흥분됨
- 배려심(care): 감사함,고마움,관심,따뜻함 / 존경심,다정함,자랑스러움,애정,연민 / 깊은 사랑,헌신,봉사하고 싶음,감동받음
- 자신감(confidence): 유능함,열린 마음,침착함,안정감 / 자랑스러움,활발함,단단함,당당함 / 영감받음,자신만만함,과감함,확신
- 활력(energy): 가벼움,느긋함,여유로움,편안함 / 신선함,활기참,집중됨,의욕적 / 강한 열정,넘치는 에너지,폭발적 추진력
- 불확실함(unease): 무관심,흥미 없음,생기 없음,멍함 / 냉담함,지루함,따분함,무기력함 / 압도됨,혼란스러움,막막함,무너짐
- 두려움(fear): 조심스러움,긴장됨,불편함,걱정됨 / 불안함,무서움,초조함,전전긍긍 / 공포,경악,패닉,극심한 두려움
- 슬픔(sad): 서운함,기분 저조,외로움,쓸쓸함 / 그리움,씁쓸함,허전함,슬픔 / 비통함,한스러움,절망,깊은 슬픔
- 분노(anger): 짜증남,불편함,답답함,못마땅함 / 화남,억울함,분함,방어적 / 격분,분노,복수심,폭발 직전
`;

const SYSTEM_PROMPT = `당신은 CBT(인지행동치료) 기반 감정 분석 전문가입니다.
사용자의 자유로운 글을 읽고, 다음 JSON을 반환하세요.

${EMOTION_DATA}

반환 형식 (JSON만, 설명 없음):
{
  "category": "happy|care|confidence|energy|unease|fear|sad|anger 중 하나",
  "emotionWord": "위 목록에서 가장 적합한 단어 하나",
  "intensityEstimate": 0에서 100 사이 정수,
  "trigger": "유발상황 1-2문장 요약",
  "message": "이 감정이 전하는 메시지 1문장",
  "need": "충족되지 않은 욕구 또는 가치 1문장",
  "thought": "핵심 자동적 사고 1문장 (가장 강한 부정적/왜곡된 생각)",
  "distortions": ["인지왜곡 종류 1-2개. 선택지: 전부 아니면 전무,과잉일반화,정신적 여과,긍정 격하,독심술,예언자적 사고,확대/축소,감정적 추론,당위진술,낙인찍기,개인화"],
  "reframe": "재구성된 균형잡힌 생각 1-2문장",
  "actionNow": "지금 당장 할 수 있는 작은 행동 1가지",
  "actionNext": "나중에 계획할 더 큰 행동 1가지"
}`;

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization, apikey, x-client-info",
      },
    });
  }

  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  try {
    const { text } = await req.json();

    if (!text || typeof text !== "string" || text.trim().length < 5) {
      return new Response(JSON.stringify({ error: "텍스트를 입력해주세요." }), {
        status: 400,
        headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
      });
    }

    const client = new Anthropic();

    const message = await client.messages.create({
      model: "claude-haiku-4-5-20251001",
      max_tokens: 1024,
      system: SYSTEM_PROMPT,
      messages: [{ role: "user", content: text.trim() }],
    });

    const raw = (message.content[0] as { type: string; text: string }).text.trim();

    // JSON 파싱 — 첫 번째 { 부터 마지막 } 까지만 추출
    const jsonMatch = raw.match(/\{[\s\S]*\}/);
    if (!jsonMatch) throw new Error("No JSON found in response");
    const result = JSON.parse(jsonMatch[0]);

    const corsHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "Content-Type, Authorization, apikey, x-client-info",
    };
    return new Response(JSON.stringify(result), {
      headers: { "Content-Type": "application/json", ...corsHeaders },
    });
  } catch (err) {
    console.error("analyze-emotion error:", err);
    return new Response(JSON.stringify({ error: "분석 중 오류가 발생했습니다." }), {
      status: 500,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type, Authorization, apikey, x-client-info",
      },
    });
  }
});
