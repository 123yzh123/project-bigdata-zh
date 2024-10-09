package net.bwie.flume.interceptor;

import com.alibaba.fastjson.JSON;
import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.interceptor.Interceptor;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.stream.Collectors;


/*
   对Flume实时采集日志数据，进行过滤操作：将非json字符串直接过滤
 */
public class ETLInterceptor implements Interceptor {

    /**
     * todo：拦截器处理数据Event之前初始化工作
     */
    @Override
    public void initialize() {

    }

    /**
     * todo：对每条数据进行处理，输入Event，输出Event
     */
    @Override
    public Event intercept(Event event) {
        // 获取Event中body数据
        byte[] body = event.getBody();
        // 转换二进制数组为字符串
        String log = new String(body, StandardCharsets.UTF_8);
        //解析json字符串

        try {
            JSON.parse(log);
            return event;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * todo：对多条数据Event进行处理，并且返回
     */
    @Override
    public List<Event> intercept(List<Event> list) {
        // Stream流失编程，过滤掉异常数据
        return list
                .stream()
                .filter(event -> null != intercept(event))
                .collect(Collectors.toList());
    }

	/**
	 * todo：拦截器数据处理完成后，收尾工作
	 */
    @Override
    public void close() {

    }

	/**
	 * todo：静态内部类--建造类，实现方法，创建拦截器的对象
	 */
	public static class Builder implements Interceptor.Builder {

		@Override
		public Interceptor build() {
			return new ETLInterceptor();
		}

		@Override
		public void configure(Context context) {

		}
	}
}
