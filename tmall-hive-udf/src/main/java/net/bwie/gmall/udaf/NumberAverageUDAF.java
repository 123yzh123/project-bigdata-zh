package net.bwie.gmall.udaf;

import org.apache.hadoop.hive.ql.exec.Description;
import org.apache.hadoop.hive.ql.exec.UDAF;
import org.apache.hadoop.hive.ql.exec.UDAFEvaluator;

/**
 * 自定义UDAF函数，计算多个数字平均值
 */
@Description(name = "number_avg",
	value = "_FUNC_(a) - Returns the mean of a set of numbers.")
public class NumberAverageUDAF extends UDAF {

	public static class AverageState {
		private long allCnt ;
		private double allSum ;
	}

	public static class AverageEvaluator implements UDAFEvaluator {

		AverageState state ;

		public AverageEvaluator() {
			super();
			state = new AverageState();
			init();
		}

		@Override
		public void init() {
			state.allCnt = 0 ;
			state.allSum = 0.0 ;
		}

		/**
		 * 每个分区数据一条条如何处理
		 */
		public boolean iterate(Double item){
			if(item != null){
				state.allCnt += 1;
				state.allSum += item;
			}
			return true ;
		}

		/**
		 * 每个任务处理数据结束后返回结果
		 */
		public AverageState terminatePartial() {
			return state.allCnt == 0 ? null : state;
		}

		/**
		 * 分区间数据merge合并操作，返回boolean类型
		 */
		public boolean merge(AverageState averageState){
			if(averageState != null){
				state.allCnt += averageState.allCnt;
				state.allSum += averageState.allSum;
			}
			return true ;
		}

		/**
		 * 返回最终的聚合函数结果
		 */
		public Double terminate(){
			return state.allCnt == 0 ? null : state.allSum / state.allCnt;
		}
	}
}
