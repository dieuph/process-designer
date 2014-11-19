package org.authentication.features;

public class RandomStringGenerator {
	public static enum Mode {
		ALPHA, ALPHANUMERIC, NUMERIC, ALPLANUMERICSPCECIALCHAR
	}

	public static String generateRandomString(int length, Mode mode) {
		StringBuffer buffer = new StringBuffer();
		String characters = "";
		switch (mode) {
		case ALPHA:
			characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
			break;
		case ALPHANUMERIC:
			characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
			break;
		case NUMERIC:
			characters = "1234567890";
			break;
		case ALPLANUMERICSPCECIALCHAR:
			characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*_=+-/";
			break;
		}
		int charactersLength = characters.length();
		for (int i = 0; i < length; i++) {
			double index = Math.random() * charactersLength;
			buffer.append(characters.charAt((int) index));
		}
		return buffer.toString();
	}
//	public static void main(String[] args) {
//		System.out.println(RandomStringGenerator.generateRandomString(8,
//				RandomStringGenerator.Mode.ALPHANUMERIC));
//	}
}
