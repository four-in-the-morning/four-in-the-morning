<%@ page 
	language="java" 
	import="java.util.*,java.io.*,java.sql.*"
%>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>

<%!
public abstract class FileUploadBase {
    protected Map<String, String> parameters = new HashMap<String, String>();// 保存普通form表单域
    
    protected String encoding = "utf-8"; // 字符编码，当读取上传表单的各部分时会用到该encoding

    protected UploadFileFilter filter = null; // 文件过滤器, 默认为NULL 不过滤
    
    /**
     * The directory in which uploaded files will be stored, if stored on disk.
     */
    protected int sizeThreshold = DiskFileItemFactory.DEFAULT_SIZE_THRESHOLD;

    /**
     * 
     * The maximum size permitted for the complete request, as opposed to
     * 
     * {@link #fileSizeMax}. A value of -1 indicates no maximum.
     * 
     */
    protected long sizeMax = -1;

    /**
     * The directory in which uploaded files will be stored, if stored on disk.
     */
    protected File repository;
    
    public String getParameter(String key) {
        return parameters.get(key);
    }

    public String getEncoding() {
        return encoding;
    }

    public void setEncoding(String encoding) {
        this.encoding = encoding;
    }

    /**
     * 获取上传文件最大的大小，单位为Byte(字节），为-1时表示无限制
     * @return
     */
    public long getSizeMax() {
        return sizeMax;
    }

    /**
     * 设置上传文件最大的大小，单位为Byte(字节），为-1时表示无限制
     * @param sizeMax
     */
    public void setSizeMax(long sizeMax) {
        this.sizeMax = sizeMax;
    }

    public int getSizeThreshold() {
        return sizeThreshold;
    }

    public void setSizeThreshold(int sizeThreshold) {
        this.sizeThreshold = sizeThreshold;
    }

    /**
     * Returns the directory used to temporarily store files that are larger
     * than the configured size threshold.
     * 
     * @return The directory in which temporary files will be located.
     * 
     * @see #setRepository(java.io.File)
     * 
     */
    public File getRepository() {
        return repository;
    }

    /**
     * Sets the directory used to temporarily store files that are larger than
     * the configured size threshold.
     * 
     * @param repository
     *            The directory in which temporary files will be located.
     * 
     * @see #getRepository()
     * 
     */
    public void setRepository(File repository) {
        this.repository = repository;
    }
    
    /**
     * 获取参数列表
     * @return
     */
    public Map<String, String> getParameters() {
        return parameters;
    }

    /**
     * 获取过滤器
     * @return
     */
    public UploadFileFilter getFilter() {
        return filter;
    }

    /**
     * 设置文件过滤器，不符合过滤器规则的将不被上传
     * @param filter
     */
    public void setFilter(UploadFileFilter filter) {
        this.filter = filter;
    }
    
    /**
     * 验证文件是否有效
     * @param item
     * @return
     */
    protected boolean isValidFile(FileItem item){
        return item == null || item.getName() == "" || item.getSize() == 0 || (filter != null && !filter.accept(item.getName())) ? false : true;
    }
}

public interface UploadFileFilter {
    /**
     * 通过文件名后缀判断文件是否被接受
     * @param filename 文件名，不包括路径
     * @return
     */
    public boolean accept(String filename);
}

public class SingleFileUpload extends FileUploadBase {
    private FileItem fileItem;

    /**
     * 
     * @param request
     * @throws UnsupportedEncodingException
     */
    public void parseRequest(HttpServletRequest request)
            throws UnsupportedEncodingException {

        DiskFileItemFactory factory = new DiskFileItemFactory();

        factory.setSizeThreshold(sizeThreshold);

        if (repository != null)
            factory.setRepository(repository);

        ServletFileUpload upload = new ServletFileUpload(factory);

        upload.setHeaderEncoding(encoding);

        try {
            List<FileItem> items = upload.parseRequest(request);

            for (FileItem item : items) {
                if (item.isFormField()) {
                    String fieldName = item.getFieldName();
                    String value = item.getString(encoding);
                    parameters.put(fieldName, value);
                } else {

                    if (!super.isValidFile(item)) {
                        continue;
                    }
                    
                    if (fileItem == null)
                        fileItem = item;
                }
            }

        } catch (FileUploadException e) {
            e.printStackTrace();
        }
    }

    /**
     * 上传文件, 调用该方法之前必须先调用 parseRequest(HttpServletRequest request)
     * @param fileName 完整文件路径
     * @throws Exception
     */
    public void upload(String fileName) throws Exception {
        File file = new File(fileName);
        uploadFile(file);
    }

    /**
     * 上传文件, 调用该方法之前必须先调用 parseRequest(HttpServletRequest request)
     * @param parent 存储的目录
     * @throws Exception
     */
    public void upload(File parent) throws Exception {
        if (fileItem == null)
            return;

        String name = fileItem.getName();
        File file = new File(parent, name);
        uploadFile(file);
    }

    public void upload(File parent, String newFileName) throws Exception {
        if (fileItem == null)
            return;

        File file = new File(parent, newFileName);
        uploadFile(file);
    }
    
    private void uploadFile(File file) throws Exception{
        if (fileItem == null)
            return;

        long fileSize = fileItem.getSize();
        if (sizeMax > -1 && fileSize > super.sizeMax){
            String message = String.format("the request was rejected because its size (%1$s) exceeds the configured maximum (%2$s)", fileSize, super.sizeMax);
                    
            throw new org.apache.commons.fileupload.FileUploadBase.SizeLimitExceededException(message, fileSize, super.sizeMax);
        }
        
        String name = fileItem.getName();
        fileItem.write(file);
    }
    
    /**
     * 获取文件信息
     * 必须先调用 parseRequest(HttpServletRequest request)
     * @return
     */
    public FileItem getFileItem() {
        return fileItem;
    }
}
%>