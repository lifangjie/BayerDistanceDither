uniform float bayerMatrix[256];
uniform float ditherRange;

void ClipByBayerDither(float depth, UNITY_VPOS_TYPE screenPos) {
	depth = ditherRange - LinearEyeDepth(depth) * ditherRange;
	clip(depth - bayerMatrix[(screenPos.x * 16 + screenPos.y) % 256]);
}