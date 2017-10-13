package com.njcit.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.njcit.bean.Emptal;
import com.njcit.bean.Msg;
import com.njcit.service.EmplService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/***
 * 处理员工
 */
@Controller
public class EmplControllder {

    @Autowired
    private EmplService emplService;

    /**
     * G：删除单个，批量 -> 保存
     * 单个删除 : 参数1
     * 批量删除 :　参数1 -参数2 -参数3
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{ids}", method = RequestMethod.DELETE)
    public Msg deleteEmp(@PathVariable("ids") String ids) {
        if (ids.contains("-")) {
            List<Integer> list = new ArrayList<Integer>();
            String[] split = ids.split("-");
            for (String s : split) {
                list.add(Integer.parseInt(s));
            }
            emplService.deleteBatch(list);
        } else {
            Integer id = Integer.parseInt(ids);
            emplService.deleteEmp(id);
        }
        return Msg.success();
    }

    /**
     * F: 更新 -> 保存
     * 这边修改员工的提交方式是PUT，但是Tomcat支持PUT请求是十分不好的，但是我们现在使用的SpringMVC对这个进行了封装，
     * 使得我们可以直接对这个请求进行操作
     *
     * @return Msg
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
    public Msg updateEmps(Emptal emptal) {
        emplService.updateEmp(emptal);
        return Msg.success();
    }

    /**
     * E、根据ID来获取员工表里面的信息
     * 这里面的@PathVariable("id") 的意思是说从路径里面取出id
     *
     * @return Msg
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
    public Msg getEmps(@PathVariable("id") Integer id) {
        Emptal emptal = emplService.getEmp(id);
        return Msg.success().add("emp", emptal);

    }

    /**
     * D、校验用户名是否可用的方法
     *
     * @param empName
     * @return 如果返回值是true：0 那就表示可用 . 如果返回值是false ：>0 那就表示不可用
     */
    @RequestMapping(value = "/checkUser")
    @ResponseBody
    public Msg checkUser(@RequestParam("empName") String empName) {
        boolean result = emplService.checkUser(empName);
        if (result) {
            return Msg.success().add("va-msg", "后台用户名可用"); // 表示用户名是可用的
        } else {
            return Msg.fail().add("va-msg", "后台用户名不可用"); //表示用户名是不可用的
        }
    }

    /**
     * C、采用AJAX解析的方式来保存员工数据(POST方式)。
     * 首先是页面发送AJAX的请求，然后里面携带了data的数据(里面是输入框里面的数据)
     * 然后将携带过来的数据包装成一个对象传到数据库中来执行插入操作
     * 这里面的@Valid注释的意思是采用JSR303的注释的方式对传递进来的对象进行校验
     * 这里面的result是绑定的数据
     */

    @RequestMapping(value = "/emp", method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmps(@Valid Emptal emptal, BindingResult result) {
        // 后台校验
        if (result.hasErrors()) {
            Map<String, Object> map = new HashMap<String, Object>();
            List<FieldError> errors = result.getFieldErrors(); // 返回的错误信息集合
            for (FieldError fieldError : errors) {
                System.out.println("错误的字段名是:" + fieldError.getField()); // 获取错误的字段名ID
                System.out.println("错误的信息是:" + fieldError.getDefaultMessage()); //获取错误的信息
                map.put(fieldError.getField(), fieldError.getDefaultMessage()); // 将错误ID作为键，错误信息作为值用Map集合来存储
            }
            return Msg.fail().add("errorfields", map); // 将错误信息传递给客户端
        } else {
            emplService.saveEmps(emptal);
            return Msg.success();
        }


    }

    /**
     * B、采用AJAX解析的方式来获取带有部门信息的员工表
     * 1.这里的方法的返回值的类型是PageInfo（JSON数据的形式返回）,而不是直接返回一个视图，
     * 这样做的目的就是可以采用AJAX的请求方式来做到异步处理数据，但是这样做是有局限性的.
     * 为什么这样说呢？因为我们这边仅仅是对数据进行查询，如果进行全部的CRUD的操作的话，就不知道执行的方法是否执行成功
     * 这样的程序设计起来是不严谨的，所以这边需要一个具备带有状态码和返回的消息来告诉我们是否执行成功
     * 2. 使用JSON的处理方式来重新使用AJAX的请求方式来得到数据，这样是解决不同的设备(android,IOS)的页面刷新兼容性
     * 也就是说采用异步处理的方式做到局部刷新页面,来得到数据
     * ResponseBodyd的作用是让返回值的数据类型是JSON的形式
     */
    @RequestMapping(value = "/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
        PageHelper.startPage(pn, 5); // 1、前面传递的参数是页码，后面的参数是代表表格里面显示几行的数据
        List<Emptal> emps = emplService.getAll(); // 2、调用Service层的方法来获取数据
        PageInfo pageInfo = new PageInfo(emps, 5); // 3、将获取到的数据传递到pageInfo中，并且设置该页面显示的分页         条显示5 页的数据
        /**
         * 1. 这里面包含的就是一个带有数据的信息的MSG对象
         * 2.首先是调用Msg里面的带有成功的方法(suceess)，由于返回值是Msg对象，
         *   所以在这边可以继续调用里面的带有用户信息的add方法,这样就可以得到一个带有所有用户信息的JSON数据了
         */
        return Msg.success().add("pageInfo", pageInfo);
    }

    /**
     * A、页面的跳转实现
     *
     * @RequestParam 前面的value代表页码，后面的default表示从第几页开始，这个是可以修改的，传递参数
     * model是表示视图，将前面的数据存储到视图里面，传到页面
     * 而pageHelper是为分页准备的，设置pageHelper显示第几页，然后指定每页显示几行数据
     * 而pageInfo则是将查询结果的存储起来，并且显示这个当前的页面显示几页的数据
     * 最后用model来存储页面
     */
//    @RequestMapping(value = "/emps")
    public String getList(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {
        PageHelper.startPage(pn, 5);
        List<Emptal> emps = emplService.getAll();
        PageInfo pageInfo = new PageInfo(emps, 5);
        List<Emptal> empse = pageInfo.getList();
        model.addAttribute("pageInfo", pageInfo);
        return "EmplList";
    }


}