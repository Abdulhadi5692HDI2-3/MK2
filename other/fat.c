#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include <Windows.h>


#define NoDefaultLib_Assert(expr) if (!(expr)) { \
		printf("ASSERT: %s at %d", __FILE__, __LINE__); \
	}

#define __Assert(expr) NoDefaultLib_Assert(expr)


#pragma pack(push, 1)
typedef struct _BootParameterBlock {
	// OEM Parameter block
	uint8_t BootJumpInstruction[3]; /* jmp short 3C
								      nop         */
	uint8_t OEMName[8]; // MSWIN4.1 | Must be 8 bytes
	wchar_t BytesPerSector;
	uint8_t SectorsPerCluster;
	wchar_t ReservedSectors;
	uint8_t NumberOfFats;
	wchar_t RootDirEntries;
	wchar_t Sectors;
	uint8_t MediaDescriptorByte;
	wchar_t SectorsPerFat;
	wchar_t SectorsPerTrack;
	wchar_t NumberOfHeads;
	uint32_t HiddenSectors;
	uint32_t HugeSectors;
		
	// Extended OEM Parameter block (FAT12+)
	uint8_t DriveNumber;
	uint8_t Reserved; // for winnt this just would be flags
	uint8_t BootSignature;
	uint32_t VolumeID;
	uint8_t VolumeLabel[11];
	uint8_t FileSystemType[8];
} BootParameterBlock;
#pragma pack(pop, 1)


BootParameterBlock BootSector;
char* fat;

// Read the Boot Sector from the disk image
BOOL ReadBootSector(FILE* Img) {
	return fread(&BootSector, sizeof(BootSector), 1, Img);
}

// Read sectors
BOOL ReadSectors(FILE* Img, uint32_t lba, uint32_t count, void* bufferOut) {
	bool ok = true;
	ok = ok && (fseek(Img, lba * BootSector.BytesPerSector, SEEK_SET) == 0);
	ok = ok && (fread(bufferOut, BootSector.BytesPerSector, count, Img) == count);
	return ok;
}
 
// Read FAT
BOOL ReadFAT(FILE* Img) {
	fat = (char*) malloc(BootSector.SectorsPerFat * BootSector.BytesPerSector);
	return ReadSectors(Img, BootSector.ReservedSectors, BootSector.SectorsPerFat, fat);
}

INT main(int ArgCount, char** Args) {
	if (ArgCount < 3) {
		printf("Syntax: %s <disk image file> <file name>\n", Args[0]);
		return -1;
	}
	
	FILE* DiskImg = fopen(Args[1], "rb");
	if (!DiskImg) {
		fprintf(stderr, "FATAL: Cannot open disk img %s!", Args[1]);
		return -1;
	}
	if (!ReadBootSector(DiskImg)) {
		fprintf(stderr, "FATAL: Could not read boot sector from disk image!");
		return -2;
	}
	
	if (!ReadFAT(DiskImg)) {
		fprintf(stderr, "FATAL: Could not read FAT from disk image!");
		return -1;
	}
	
	return 0;
}


// END OF FILE
