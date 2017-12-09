if __name__ == '__main__':
    KEYS = 'abcdefghijklmnopqrstuvwxyz0123456789'
    KEY_CODES = [
            0x1c, 0x32, 0x21, 0x23,
            0x24, 0x2b, 0x34, 0x33, 0x43,
            0x3b, 0x42, 0x4b, 0x3a, 0x31,
            0x44, 0x4d, 0x15, 0x2d, 0x1b,
            0x2c, 0x3c, 0x2a, 0x1d, 0x22,
            0x35, 0x1a,
            0x45, 0x16, 0x1e, 0x26, 0x25,
            0x2e, 0x36, 0x3d, 0x3e, 0x46
    ]

    L = len(KEYS)
    for i in range(0, L):
        print('CMPI R2 %d' % KEY_CODES[i])
        print('BTEQZ INT_PS2_' + KEYS[i])
        print('NOP')
        print

    for i in range(0, L):
        print('INT_PS2_' + KEYS[i] + ':')
        print('LI R6 %d' % ord(KEYS[i]))
        print('B INT_PS2_PRINT')
        print('NOP')
        print

