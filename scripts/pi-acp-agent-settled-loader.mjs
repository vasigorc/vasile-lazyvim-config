const AGENT_END_CASE = 'case "agent_end": {';
const AGENT_SETTLED_CASE = 'case "agent_settled": {';

export function patchPiAcpSource(source) {
  if (source.includes(AGENT_SETTLED_CASE)) {
    return source;
  }

  if (!source.includes(AGENT_END_CASE)) {
    throw new Error("Unsupported pi-acp build: agent_end handler not found");
  }

  return source.replace(
    AGENT_END_CASE,
    `${AGENT_END_CASE}\n        break;\n      }\n      ${AGENT_SETTLED_CASE}`,
  );
}

export async function load(url, context, nextLoad) {
  const result = await nextLoad(url, context);
  if (!/\/pi-acp\/dist\/index\.js$/.test(new URL(url).pathname)) {
    return result;
  }

  const source =
    typeof result.source === "string" ? result.source : Buffer.from(result.source).toString("utf8");

  return {
    ...result,
    source: patchPiAcpSource(source),
  };
}
