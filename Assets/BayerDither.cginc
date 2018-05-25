uniform float bayerMatrix[256];
uniform float ditherRange;

void ClipByBayerDither(float depth, UNITY_VPOS_TYPE screenPos) {
	depth = ditherRange - LinearEyeDepth(depth) * ditherRange;
	screenPos = frac(floor(screenPos)/16);
	clip(depth - bayerMatrix[screenPos.x*256 + screenPos.y*16]);
}