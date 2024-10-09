package net.bwie.flume.interceptor;

import com.alibaba.fastjson.JSONObject;
import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.interceptor.Interceptor;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 使用Flume拦截器解决日志数据存储HDFS时，按照每日分区存储的零点数据漂移问题。
 * @author bawei
 */
public class TimestampInterceptor implements Interceptor {

	@Override
	public void initialize() {
	}

	@Override
	public Event intercept(Event event) {
		// Event数据header和body
		Map<String, String> headers = event.getHeaders();
		String log = new String(event.getBody(), StandardCharsets.UTF_8);
		// 解析日志
		JSONObject jsonObject = JSONObject.parseObject(log);
		// 获取数据时间ts
		String ts = jsonObject.getString("ts");
		// 放入头部
		headers.put("timestamp", ts);
		// 返回Event数据
		return event;
	}

	@Override
	public List<Event> intercept(List<Event> events) {
		return events
			.stream()
			.map(this::intercept)
			.collect(Collectors.toList());
	}

	@Override
	public void close() {
	}

	public static class Builder implements Interceptor.Builder{
		@Override
		public Interceptor build() {
			return new TimestampInterceptor();
		}

		@Override
		public void configure(Context context) {
		}
	}

}
