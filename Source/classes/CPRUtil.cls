public with sharing class CPRUtil {
	
	public static final Map<Integer,String>EncryptionKeyMap = new Map<Integer,String>
	{0 => 'W',1 => 'F',2 => '3',3 => '4',4 => 'C',5 => 'K',6 => 'Q',7 => 'R',8 => '7',9 => 'Y',
	 10 => 'N',11 => 'T',12 => 'U',13 => '6',14 => 'Z',15 => 'H',16 => 'J',17 => 'P',18 => '9',19 => 'E',
	 20 => 'A',21 => 'M',22 => 'D',23 => '2',24 => 'X',25 => 'V',26 => '5',27 => 'L',28 => 'G',29 => '8',
	 30 => 'S',31 => 'B'};
	
	public static String encryptCPR(String strCPREntered){
		// Take CPR (DDMMYYXXXX) and split it into DD (left) and MMYYXXXX (right
		Integer intLeft = Integer.valueOf(strCPREntered.substring(0, 2));
		Integer intRight = Integer.valueOf(strCPREntered.substring(2));
		// Shift DD left by 24 bits (is the same as multiplying by 2^24)
		Integer leftA = intLeft * 16777216;
		
		// add the left-shifted DD value with the original MMYYXXXX value
		// Now, the right-most 24 bits contain the MMYYXXXX, and the 5 bits to the left of those contain the DD value
		Integer sum = leftA + intRight;
		system.debug('==sum==='+sum);
		// convert the sum to a binary string
		String sumBytes = BaseConverter.generateBase32Number(sum,32);
		system.debug('sumBytes========'+sumBytes);
		// Split the binary string into 6 blocks. Discard the first two bits, and split it into 6 blocks of 5 bits each
		String[] blocks = new List<String>{
			sumBytes.substring(2, 7),
			sumBytes.substring(7, 12),
			sumBytes.substring(12, 17),
			sumBytes.substring(17, 22),
			sumBytes.substring(22, 27),
			sumBytes.substring(27, 32)
		};	
		
		// for each block of 5 bits, convert it to a base-10 number, and use that number as an index in the
		// encryption key. The character at that index is the encrypted value of that block
		String encryptedCPR = '';
		for (String block : blocks) {
			system.debug('block==='+block);
			Integer intChar = BaseConverter.stringByteToInteger(block);
			if(EncryptionKeyMap.containskey(intChar))
				encryptedCPR += EncryptionKeyMap.get(intChar);
		}
		
		return encryptedCPR;
	}
}