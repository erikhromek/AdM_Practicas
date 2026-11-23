#include "functions_ge2.h"

void GPS_unpack(int32_t *GPS_data, int16_t *GPS_Lat, int16_t *GPS_Long, uint16_t longitud) {
	const int16_t mask = 0xFFF;
	int32_t aux;

	for (uint16_t i = longitud; i > 0; i--)
	{
		// 0x00123C98, 123 = Lat, C98 = Lon
		// Lat va desde 12 a 23
		// Lon va desde 0 a 11
		aux = GPS_data[i-1];
		GPS_Lat[i-1] = (int16_t) ((aux >> 12) & mask);
		GPS_Long[i-1] = (int16_t) (aux & mask);
		if (GPS_Lat[i-1] & 0x800)
			GPS_Lat[i-1] -= 4096;

		if (GPS_Long[i-1] & 0x800)
			GPS_Long[i-1] -= 4096;

	}
}
