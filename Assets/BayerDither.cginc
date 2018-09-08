uniform float bayerMatrix[256];

void ClipByBayerDither(float alpha, UNITY_VPOS_TYPE screenPos) {
	screenPos = frac(floor(screenPos)/16);
	clip(alpha - bayerMatrix[screenPos.x*256 + screenPos.y*16]);
}