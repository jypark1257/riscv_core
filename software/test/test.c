#define dmem_offset 0x00000000

int main(){
    unsigned int *dmem = (unsigned int *) (dmem_offset);
    
    for(int i = 1; i < 256; i++) { 
        dmem[i] = i * 2;
    }
    return 0;
}