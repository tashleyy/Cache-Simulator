import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;

public class EE352_Final_Tjahjadi {
	public static void main(String[] args) {
		generateTrace(100);
		// Get Parameters
		
		// t0 = cacheBits, can be reused
		// t1 = lineBits
		// t2 = missPenalty
		// t3 = linesPerSetBits
		// t4 = totalHits
		// t5 = totalMisses
		// t6 = totalMemAcc
		// t7 = tagBits not needed though, can be reused
		// t8 = setBits
		// s0 = setIndex
		// s1 = tag
		// s2 = value of address, can be reused
		// s3 = value of setBits and lineBits of address, can be reused
		// s4 = value of lineBits of address, can be reused
		// s5 = counter1
		// s6 = counter2
		
		InputStreamReader isr = new InputStreamReader(System.in);
		BufferedReader br1 = new BufferedReader(isr); 
		int t0 = 0, t1 = 0, t2 = 0, t3 = 0, t4 = 0, t5 = 0, t6 = 0, t7 = 0, t8 = 0;
		
		try {
			System.out.print("Enter cache size: 2^");
			t0 = Integer.parseInt(br1.readLine());
			System.out.print("Enter line size: 2^");
			t1 = Integer.parseInt(br1.readLine());
			t3 = (t0 - t1) / 2;
			t8 = t0 - t1 - t3;
			t7 = 32 - t8 - t1;
			System.out.print("Enter miss penalty: ");
			t2 = Integer.parseInt(br1.readLine());
			isr.close();
			br1.close();
		} catch (IOException ioe) {
			System.out.println("IOException: " + ioe.getMessage());
		}
		System.out.println(t7 + " " + t8 + " " + t1);
		
		// Create empty cache
		int[] cache = new int[(int)Math.pow(2, t0-t1)];
		for (int i = 0; i < Math.pow(2, t0-t1); i++) {
			cache[i] = -1;
		}

		// Simulate
		try {
			FileReader fr = new FileReader("trace.txt");
			BufferedReader br2 = new BufferedReader(fr);
			String line = br2.readLine();
			while (!line.equals("Z")) {
				int s2 = Integer.parseInt(line, 16);
				int s3 = s2 % (int) Math.pow(2, t8+t1);
				int s4 = s2 % (int) Math.pow(2, t1);
				int s0 = (s3 - s4) / (int) Math.pow(2, t1);
				int s1 = s2 - s3;
				t6++;
				line = br2.readLine();
				
				int s5 = s0*(int)Math.pow(2, t3);
				int s6;
				boolean found = false; // not needed in MIPS because we can use jump
				while (true) {
					if (s5 == (s0+1)*(int)Math.pow(2, t3)) break;
					if (cache[s5] == s1) {
						found = true; // hit
						t4++;
						s6 = s5+1;
						while (true) {
							if (s6 == (s0+1)*(int)Math.pow(2, t3)) {
								cache[s6-1] = s1;
								break;
							}
							if (cache[s6] == -1) {
								cache[s6-1] = s1;
								break;
							}
							cache[s6-1] = cache[s6];
							s6++;
						}
						break;
					}
					s5++;
				}
				if (found) continue;
				t5++; // miss
				s5 = (s0+1)*(int)Math.pow(2, t3)-1;
				s6 = s0*(int)Math.pow(2, t3)+1;
				if (cache[s5] == -1) {
					while(true) {
						if (s5 == s0*(int)Math.pow(2, t3)) {
							cache[s0*(int)Math.pow(2, t3)] = s1;
							break;
						}
						if (cache[s5-1] != -1) {
							cache[s5] = s1;
							break;
						}
						s5--;
					}
				} else {
					while (true) {
						if (s6 == (s0+1)*Math.pow(2, t3)) break;
						cache[s6-1] = cache[s6];
						s6++;
					}
					cache[s6-1] = s1;
				}
			}
			br2.close();
			fr.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		System.out.println(t4 + " " + t5 + " " + t6);
		System.out.println("Total Hit Rate: " + (double)Math.round(((double)t4 / t6 * 100) * 10000) / 10000 + "%");
		System.out.println("Total Run Time: " + (t6 + t5 * t2));
		System.out.println("Average Memory Access Latency: " + (double)Math.round((((double)t6 + (double)t5 * t2) / t6) * 10000) / 10000);
	}
	
	private static void generateTrace(int size) {
		try {
			FileWriter fw = new FileWriter("trace.txt");
			PrintWriter pw = new PrintWriter(fw);
			ArrayList<Integer> memoryAccesses = new ArrayList<Integer>();
			Random rand = new Random();
			for (int i = 0; i < size;) {
				int d = rand.nextInt((int)Math.pow(2, 32));
				int repeat = rand.nextInt(8);
				for (int j = 0; j < repeat && i < size; j++, i++) {
					memoryAccesses.add(d);
				}
			}
			Collections.shuffle(memoryAccesses);
			for (int i = 0; i < size; i++) {
				String str = Integer.toHexString(memoryAccesses.get(i));
				while (str.length() < 8) {
					str = "0" + str;
				}
				pw.println(str);
			}
			pw.println("Z");
			pw.flush();
			pw.close();
			fw.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
