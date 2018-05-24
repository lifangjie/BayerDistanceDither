uniform float bayerMatrix[256];
uniform float DitherRange;

void ClipByBayerDither(float depth, UNITY_VPOS_TYPE screenPos) {
	depth = DitherRange - LinearEyeDepth(depth) * DitherRange;
	screenPos = frac(floor(screenPos)/16);
	clip(depth - bayerMatrix[screenPos.x*256 + screenPos.y*16]);
}